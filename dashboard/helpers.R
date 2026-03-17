library(DBI)
library(RSQLite)
library(dplyr)
library(xml2)

# ── Database ──────────────────────────────────────────────────────────────────

# Use WAL mode + busy timeout on every connection to prevent locking errors
# when the background test runner writes while Shiny's timer reads.
db_connect <- function(db_path) {
  con <- dbConnect(SQLite(), db_path, synchronous = NULL)
  dbExecute(con, "PRAGMA busy_timeout = 5000")
  con
}

init_db <- function(db_path) {
  con <- db_connect(db_path)
  on.exit(dbDisconnect(con))

  # WAL allows concurrent reads during writes; persists across connections
  dbExecute(con, "PRAGMA journal_mode = WAL")

  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS test_runs (
      run_id       TEXT PRIMARY KEY,
      started_at   TEXT,
      completed_at TEXT,
      n_domains    INTEGER,
      status       TEXT
    )
  ")

  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS domain_results (
      id                   INTEGER PRIMARY KEY AUTOINCREMENT,
      run_id               TEXT,
      domain               TEXT,
      tested_at            TEXT,
      n_articles_attempted INTEGER,
      n_http_success       INTEGER,
      pct_datetime         REAL,
      pct_author           REAL,
      pct_headline         REAL,
      pct_text             REAL,
      health               TEXT,
      error_msg            TEXT
    )
  ")

  invisible(NULL)
}

get_latest_results <- function(db_path, status_info) {
  all_scrapers <- status_info[, c("domain", "rss"), drop = FALSE]

  if (!file.exists(db_path)) {
    all_scrapers$health <- ifelse(is.na(all_scrapers$rss) | !nzchar(trimws(all_scrapers$rss)), "no_rss", "untested")
    return(all_scrapers)
  }

  con <- db_connect(db_path)
  on.exit(dbDisconnect(con))

  db_res <- dbGetQuery(con, "
    SELECT dr.*
    FROM domain_results dr
    INNER JOIN (
      SELECT domain, MAX(tested_at) AS max_at
      FROM domain_results
      GROUP BY domain
    ) latest ON dr.domain = latest.domain AND dr.tested_at = latest.max_at
  ")

  # When no tests have run yet, skip the merge and build the result directly
  # to avoid type ambiguity from merging a 0-row data frame.
  if (nrow(db_res) == 0) {
    no_rss <- is.na(all_scrapers$rss) | !nzchar(trimws(ifelse(is.na(all_scrapers$rss), "", all_scrapers$rss)))
    all_scrapers$tested_at            <- NA_character_
    all_scrapers$n_articles_attempted <- NA_integer_
    all_scrapers$n_http_success       <- NA_integer_
    all_scrapers$pct_datetime         <- NA_real_
    all_scrapers$pct_author           <- NA_real_
    all_scrapers$pct_headline         <- NA_real_
    all_scrapers$pct_text             <- NA_real_
    all_scrapers$health               <- ifelse(no_rss, "no_rss", "untested")
    all_scrapers$error_msg            <- NA_character_
    return(all_scrapers)
  }

  out <- merge(all_scrapers, db_res, by = "domain", all.x = TRUE)

  # Fill health for domains not yet tested
  no_rss_mask   <- is.na(out$rss) | !nzchar(trimws(ifelse(is.na(out$rss), "", out$rss)))
  untested_mask <- is.na(out$health)
  out$health[untested_mask &  no_rss_mask] <- "no_rss"
  out$health[untested_mask & !no_rss_mask] <- "untested"

  out
}

get_domain_history <- function(db_path, domain, limit = 50) {
  if (!file.exists(db_path)) return(data.frame())
  con <- db_connect(db_path)
  on.exit(dbDisconnect(con))
  dbGetQuery(con,
    "SELECT * FROM domain_results WHERE domain = ? ORDER BY tested_at DESC LIMIT ?",
    list(domain, limit)
  )
}

get_run_history <- function(db_path) {
  if (!file.exists(db_path)) return(data.frame())
  con <- db_connect(db_path)
  on.exit(dbDisconnect(con))
  dbGetQuery(con,
    "SELECT run_id, started_at, completed_at, n_domains, status
     FROM test_runs ORDER BY started_at DESC"
  )
}

# ── Health calculation ────────────────────────────────────────────────────────

calculate_health <- function(n_attempted, n_http_success,
                              pct_headline, pct_datetime, pct_author, pct_text) {
  if (is.na(n_attempted) || n_attempted == 0) return("broken")
  if ((n_http_success / n_attempted) < 0.5)   return("broken")
  if (!is.na(pct_text)     && pct_text     == 0) return("broken")
  if (!is.na(pct_headline) && pct_headline == 0) return("broken")

  metrics <- c(pct_datetime, pct_author, pct_headline, pct_text)
  if (any(!is.na(metrics) & metrics < 0.5)) return("degraded")

  "ok"
}

# ── RSS parsing ───────────────────────────────────────────────────────────────

get_article_urls_from_rss <- function(rss_url, n = 5) {
  tryCatch({
    h    <- curl::new_handle(timeout = 15L, useragent = "paperboy-monitor/1.0")
    resp <- curl::curl_fetch_memory(rss_url, handle = h)

    if (resp$status_code != 200) return(character(0))

    xml <- xml2::read_xml(resp$content)

    # RSS 2.0
    links <- xml2::xml_find_all(xml, "//item/link") |> xml2::xml_text()
    links <- trimws(links)

    # Atom fallback
    if (length(links) == 0 || all(!nzchar(links))) {
      links <- xml2::xml_find_all(
        xml, "//*[local-name()='entry']/*[local-name()='link']"
      ) |> xml2::xml_attr("href")
    }

    links <- links[!is.na(links) & nzchar(links)]
    head(links, n)
  }, error = function(e) character(0))
}

# ── Per-domain test ───────────────────────────────────────────────────────────

# Accepts an open connection (con) — caller is responsible for open/close.
# This avoids reopening the DB for every domain in a run.
run_domain_test <- function(domain, rss_url, con, run_id, n_articles = 3) {

  # Closure captures con/run_id/domain so call sites stay concise
  save_result <- function(n_attempted, n_http_success,
                           pct_datetime, pct_author, pct_headline, pct_text,
                           health, error_msg = NA_character_) {
    dbExecute(con,
      "INSERT INTO domain_results
         (run_id, domain, tested_at, n_articles_attempted, n_http_success,
          pct_datetime, pct_author, pct_headline, pct_text, health, error_msg)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      list(run_id, domain, format(Sys.time()),
           n_attempted, n_http_success,
           pct_datetime, pct_author, pct_headline, pct_text,
           health, error_msg)
    )
  }

  article_urls <- get_article_urls_from_rss(rss_url, n = n_articles)

  if (length(article_urls) == 0) {
    save_result(0, 0, NA, NA, NA, NA, "broken", "No article URLs found in RSS feed")
    return(invisible(NULL))
  }

  tryCatch({
    collected      <- paperboy::pb_collect(article_urls, verbose = FALSE)
    n_attempted    <- nrow(collected)
    n_http_success <- sum(collected$status == 200L, na.rm = TRUE)

    if (n_http_success == 0L) {
      save_result(n_attempted, 0, NA, NA, NA, NA, "broken", "All HTTP requests failed")
      return(invisible(NULL))
    }

    delivered <- paperboy::pb_deliver(
      collected,
      try_default  = FALSE,
      ignore_fails = TRUE,
      verbose      = FALSE
    )

    if (nrow(delivered) == 0) {
      save_result(n_attempted, n_http_success, 0, 0, 0, 0, "broken", "Parser returned no results")
      return(invisible(NULL))
    }

    txt          <- as.character(delivered$text)
    pct_datetime <- mean(!is.na(delivered$datetime))
    pct_author   <- mean(!is.na(delivered$author) & nchar(as.character(delivered$author)) > 0)
    pct_headline <- mean(!is.na(delivered$headline) & nchar(as.character(delivered$headline)) > 0)
    pct_text     <- mean(!is.na(txt) & nchar(txt) > 100)

    health <- calculate_health(
      n_attempted, n_http_success,
      pct_headline, pct_datetime, pct_author, pct_text
    )

    save_result(n_attempted, n_http_success,
                pct_datetime, pct_author, pct_headline, pct_text, health)

  }, error = function(e) {
    save_result(0, 0, NA, NA, NA, NA, "error", conditionMessage(e))
  })

  invisible(NULL)
}

# ── Full test run ─────────────────────────────────────────────────────────────

# domains = NULL runs all testable scrapers; otherwise runs the subset.
# A single DB connection is held open for the entire run to avoid repeated
# open/close overhead when testing many domains.
run_tests <- function(db_path, run_id, status_info, domains = NULL, n_articles = 3) {
  testable <- status_info[!is.na(status_info$rss) & nzchar(trimws(status_info$rss)), ]
  if (!is.null(domains)) testable <- testable[testable$domain %in% domains, ]

  con <- db_connect(db_path)
  on.exit(dbDisconnect(con))

  dbExecute(con,
    "INSERT INTO test_runs (run_id, started_at, n_domains, status) VALUES (?, ?, ?, 'running')",
    list(run_id, format(Sys.time()), nrow(testable))
  )

  for (i in seq_len(nrow(testable))) {
    run_domain_test(testable$domain[i], testable$rss[i], con, run_id, n_articles)
  }

  dbExecute(con,
    "UPDATE test_runs SET completed_at = ?, status = 'completed' WHERE run_id = ?",
    list(format(Sys.time()), run_id)
  )

  invisible(run_id)
}
