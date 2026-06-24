#' Create a new parser
#'
#' Create a new parser for a given domain.
#'
#' @param x A character string of a URL to the newspaper to create a parser for.
#' @param author A Markdown formatted character string of the author of the
#'   parser.
#' @param issue A Markdown formatted link to the issue associated with the
#'   parser (please file an issue before starting to work on a new parser).
#' @param rss An optional character string of the RSS feed associated with the
#'   parser.
#' @param test_data An optional data frame of test data to use for testing the
#'   parser.
#'
#' @details The function will process through the steps for creating a new
#' parser, which are:
#'
#' 1. Creating a file from the parser template
#' 2. Trying to find an RSS feed link
#' 3. Add a new entry to the status.csv file, which contains information about all parsers.
#' 4. Edit the parsers to extract required and additional information from articles on the site.
#' 5. Check the parser for consistency (can it be loaded? are all entries present?).
#' 5. Check against test data (either provided in the function or downloaded from the RSS feed).
#' 6. Finalise CSV entry
#'
#' As might be obvious, not all steps can be performed in a single action.
#' Rather the idea is to run the function multiple times, until all is done.
#'
#'
#' @return A message indicating the success or failure of the parser creation.
#' @export
#'
#' @examples
#' \dontrun{
#' use_new_parser(x = "https://www.buzzfeed.com/",
#'                author = "[@JBGruber](https://github.com/JBGruber/)",
#'                issue = "[#1](https://github.com/JBGruber/paperboy/issues/1)",
#'                rss = "https://www.buzzfeed.com/rss")
#' }
#' @md
use_new_parser <- function(
  x,
  author = "",
  issue = "",
  rss = NULL,
  test_data = NULL
) {
  x <- utils::head(adaR::ada_get_domain(x), 1)

  cli::cli_progress_step(
    "Creating R file",
    msg_done = "Created R file with function template"
  )
  r_file <- pb_new(x)
  cli::cli_progress_done()

  if (is.null(rss)) {
    cli::cli_progress_step(
      "Trying to find RSS feed",
      msg_done = "RSS feed noted",
      msg_failed = "No RSS feed in the usual locations. Add to inst/status.csv manually"
    )
    rss <- pb_find_rss(x)
  }
  if (rss == "") {
    cli::cli_progress_done(result = "failed")
  } else {
    cli::cli_progress_done()
  }

  if (is_pb()) {
    cli::cli_progress_step(
      "Adding entry to inst/status.csv",
      msg_done = "Added entry to inst/status.csv",
      msg_failed = "inst/status.csv could not be found"
    )

    if (file.exists("inst/status.csv")) {
      status <- utils::read.csv("inst/status.csv")
      if (!gsub("^www.", "", x) %in% status$domain) {
        domain <- NULL
        status <- status %>%
          rbind(list(
            domain = sub("^www.", "", x),
            status = "![](https://img.shields.io/badge/status-requested-lightgrey)",
            author = author,
            issues = issue,
            rss = rss
          )) %>%
          dplyr::arrange(domain)
        utils::write.csv(status, "inst/status.csv", row.names = FALSE)
      } else if (rss == "") {
        # if entry already present, get rss value
        rss <- status[grepl(gsub("^www.", "", x), status$domain), "rss"]
      }

      cli::cli_progress_done()
    } else {
      cli::cli_progress_done(result = "failed")
    }
  } else {
    cli::cli_alert_info(
      "Editing of status.csv skipped as you are not in the package folder"
    )
  }

  # if file was just created, open for edit, otherwise test
  if (file.info(r_file)$atime > Sys.time() - 60) {
    edit_parser(r_file)
    exit()
  } else {
    cli::cli_progress_step(
      "Testing {r_file} for consistency",
      msg_done = "{r_file} passed tests",
      msg_failed = "{r_file} did not pass tests. Please try again"
    )

    attach(getNamespace("paperboy"))
    if (test_parser_consistency(r_file, x)) {
      cli::cli_progress_done()
    } else {
      cli::cli_progress_done(result = "failed")
      edit_parser(r_file)
      exit()
    }
  }

  cli::cli_progress_step(
    "Checking parser {r_file} for consistency",
    msg_done = "{r_file} passed tests!",
    msg_failed = "{r_file} did not pass tests."
  )

  if (is.null(test_data) && is.na(rss)) {
    cli::cli_abort("You did not provide test data or an RSS feed to collect it")
  } else if (is.null(test_data)) {
    test_data <- pb_collect(rss)
  }

  # TODO: would be good to load the new function, but neither devtools::load_all
  # nor source seem to do the trick here
  test_data_parsed <- test_parser(test_data)

  if (the$test_status != "passed") {
    cli::cli_progress_done(result = "failed")
    sel <- utils::askYesNo(
      "Would you like me to load the test data and results into your environment?",
      default = FALSE
    )
    if (sel) {
      test_data <<- test_data
      test_data_parsed <<- test_data_parsed
    }
    exit()
  }

  if (is_pb()) {
    cli::cli_progress_step(
      "Finalising entry in inst/status.csv",
      msg_done = "status.csv updated."
    )
    status <- utils::read.csv("inst/status.csv")
    status[status$domain == gsub("^www.", "", x), "status"] <-
      "![](https://img.shields.io/badge/status-gold-%23ffd700.svg)"
    cli::cli_alert_info(
      "Check the entry manually. Press quit when you're happy."
    )
    status[status$domain == gsub("^www.", "", x), ] <-
      utils::edit(status[status$domain == gsub("^www.", "", x), ])
    utils::write.csv(status, "inst/status.csv", row.names = FALSE)
  }

  cli::cli_alert_success("All done! {praise::praise()}")
}


#' Get HTML context for LLM-assisted parser development
#'
#' A text-output alternative to \link{pb_inspect} for non-interactive
#' environments such as LLM agents. Prints a compact structured summary of page
#' HTML — meta tags, JSON-LD blocks, \code{<time>} elements, most common
#' paragraph-parent selectors, and elements with keyword-bearing class names —
#' to help identify CSS selectors for the four required parser fields without
#' needing a browser.
#'
#' @param x A data frame from \link{pb_collect}.
#' @param n Integer; number of articles to summarise (default \code{1L}).
#'
#' @return Invisibly returns a character vector of summaries (one per article).
#'   Prints to the console as a side effect.
#' @export
#'
#' @examples
#' \dontrun{
#' test_data <- pb_collect("https://denverpost.com/feed")
#' pb_html_context(test_data, n = 3L)
#' }
pb_html_context <- function(x, n = 1L) {
  if (!is.data.frame(x) || !"content_raw" %in% names(x)) {
    cli::cli_abort("{.arg x} must be a data frame from {.fn pb_collect}")
  }

  x <- utils::head(x, n)

  url_col <- intersect(c("url", "link", "id"), names(x))
  url_col <- if (length(url_col) > 0L) url_col[1L] else NA_character_

  out <- vapply(
    seq_len(nrow(x)),
    function(i) {
      html <- rvest::read_html(x$content_raw[[i]])
      label <- if (!is.na(url_col)) x[[url_col]][[i]] else paste("article", i)

      # Meta tags
      meta_nodes <- rvest::html_elements(html, "meta")
      meta_key <- dplyr::coalesce(
        rvest::html_attr(meta_nodes, "name"),
        rvest::html_attr(meta_nodes, "property")
      )
      meta_content <- rvest::html_attr(meta_nodes, "content")
      keep <- !is.na(meta_key) & !is.na(meta_content) & nzchar(meta_content)
      meta_lines <- paste0(meta_key[keep], ": ", meta_content[keep])

      # JSON-LD structured data blocks
      jsonld_raw <- rvest::html_elements(
        html,
        "script[type='application/ld+json']"
      ) %>%
        rvest::html_text()
      jsonld <- if (length(jsonld_raw) > 0L) {
        paste(jsonld_raw, collapse = "\n---\n")
      } else {
        ""
      }

      # Time elements (first 3)
      time_nodes <- rvest::html_elements(html, "time")
      time_lines <- vapply(
        seq_len(min(3L, length(time_nodes))),
        function(j) {
          t <- time_nodes[[j]]
          dt <- rvest::html_attr(t, "datetime")
          cl <- rvest::html_attr(t, "class")
          tx <- rvest::html_text2(t)
          parts <- c(
            if (!is.na(dt) && nzchar(dt)) paste0("datetime=\"", dt, "\""),
            if (!is.na(cl) && nzchar(cl)) paste0("class=\"", cl, "\"")
          )
          paste0("<time ", paste(parts, collapse = " "), ">", tx, "</time>")
        },
        character(1)
      )

      # Most frequent <p> parents (top 5 candidates for article body selector)
      p_nodes <- rvest::html_elements(html, "p")
      p_parent_sels <- vapply(
        p_nodes,
        function(p) {
          parent <- xml2::xml_parent(p)
          parent_tag <- xml2::xml_name(parent)
          parent_class <- xml2::xml_attr(parent, "class")
          if (!is.na(parent_class) && nzchar(parent_class)) {
            first_class <- strsplit(parent_class, "\\s+")[[1L]][1L]
            paste0(parent_tag, ".", first_class)
          } else {
            parent_tag
          }
        },
        character(1)
      )
      freq <- sort(table(p_parent_sels), decreasing = TRUE)
      parent_lines <- utils::head(
        paste0(names(freq), ": ", as.integer(freq), " <p>"),
        5L
      )

      # Elements whose class names suggest parser-relevant content
      kw_pattern <- "author|byline|writer|headline|title|datetime|publish|date"
      all_nodes <- rvest::html_elements(html, "[class]")
      all_classes <- rvest::html_attr(all_nodes, "class")
      kw_match <- grepl(kw_pattern, all_classes, ignore.case = TRUE)
      kw_nodes <- all_nodes[kw_match]
      kw_classes <- all_classes[kw_match]
      kw_tags <- rvest::html_name(kw_nodes)
      kw_text <- gsub("\\s+", " ", rvest::html_text2(kw_nodes))
      kw_text <- substr(kw_text, 1L, 80L)
      unique_sel <- !duplicated(paste(kw_tags, kw_classes))
      kw_lines <- paste0(
        kw_tags[unique_sel],
        ".",
        gsub("\\s+", ".", kw_classes[unique_sel]),
        ": \"",
        kw_text[unique_sel],
        "\""
      )

      sections <- c(
        paste0("=== ", label, " ==="),
        "",
        "--- Meta Tags ---",
        meta_lines,
        "",
        if (nzchar(jsonld)) c("--- JSON-LD ---", jsonld, ""),
        if (length(time_lines) > 0L) c("--- Time Elements ---", time_lines, ""),
        "--- Most Common <p> Parents (article body candidates) ---",
        parent_lines,
        "",
        if (length(kw_lines) > 0L) {
          c("--- Elements with Keyword Classes ---", kw_lines, "")
        }
      )

      paste(sections, collapse = "\n")
    },
    character(1)
  )

  cat(paste(out, collapse = "\n\n"))
  invisible(out)
}


#' Create new scraper
#'
#' @param np domain or a URL of the newspaper this scraper is for.
#' @param author who wrote it.
#' @param issue is there a GitHub issue?
#'
#' @keywords internal
#' @examples
#' \dontrun{
#' paperboy:::pb_new(np = "https://www.buzzfeed.com/",
#'                   author = "[@JBGruber](https://github.com/JBGruber/)")
#'
#' paperboy:::pb_new_done()
#' }
pb_new <- function(np, author = "", issue = "") {
  np <- utils::head(url_get_domain(np), 1)
  np_ <- classify(np)

  if (is.na(np)) {
    cli::cli_abort("invalid domain name: {np}")
  }

  template <- system.file("templates", "deliver_.R", package = "paperboy") %>%
    readLines() %>%
    gsub("{{newspaper}}", np_, x = ., fixed = TRUE)

  p <- ifelse(is_pb(), "./R", ".")
  f <- file.path(p, paste0("deliver_", np_, ".R"))
  if (!file.exists(f)) {
    writeLines(template, f)
  }

  return(f)
}


#' Test a Parser
#'
#' Test a parser using a data frame from \link{pb_collect}.
#'
#' @param test_data A data frame of raw content.
#' @return A success or failure message.
test_parser <- function(test_data) {
  if (!"content_raw" %in% names(test_data)) {
    cli::cli_abort("Only works with output from {.fnc pb_collect}")
  }

  cli::cli_alert_info("Trying to parse raw data")
  test_df_parsed <- pb_deliver(test_data)
  cli::cat_line()
  total <- nrow(test_df_parsed)
  cli::cli_alert_info("Checking results")
  fails <- check_fails(test_df_parsed, "datetime", total) +
    check_fails(test_df_parsed, "author", total) +
    check_fails(test_df_parsed, "headline", total) +
    check_fails(test_df_parsed, "text", total)

  if (fails == 0) {
    the$test_status <- "passed"
    cli::cli_progress_done(
      praise::praise(
        "${Exclamation}! Test passed ${adverb}! This parser is ${adjective}!"
      )
    )
  } else {
    the$test_status <- "fail"
    cli::cli_alert_danger(
      praise::praise(
        "Some tests failed. But you will get there! Don't stop ${creating} now!"
      )
    )
  }
  invisible(test_df_parsed)
}


pct <- function(x) {
  round(x * 100, 2) %>%
    format(nsmall = 2, big.mark = ",") %>%
    paste0("%")
}


check_fails <- function(df, what, total) {
  switch(
    what,
    "datetime" = fails <- sum(is.na(df[[what]])) / total,
    "author" = fails <- (sum(df[[what]] == "NA", na.rm = TRUE) +
      sum(is.na(df[[what]]))) /
      total,
    "headline" = fails <- (sum(df[[what]] == "", na.rm = TRUE) +
      sum(is.na(df[[what]]))) /
      total,
    "text" = fails <- sum(df[[what]] == "") / total
  )

  if (fails > 0.01 & fails < 0.05) {
    cli::cli_alert_warning("{pct(fails)} of {what} values failed to parse")
  }

  if (fails >= 0.05) {
    cli::cli_alert_danger("{pct(fails)} of {what} values failed to parse")
    return(TRUE)
  }
  return(FALSE)
}


is_pb <- function() {
  n <- basename(getwd()) == "paperboy"
  d <- file.exists("DESCRIPTION")
  v <- FALSE
  if (d) {
    v <- any(grepl("Package: paperboy", readLines("DESCRIPTION"), fixed = TRUE))
  }
  n + d + v == 3L
}


test_parser_consistency <- function(f, x) {
  test <- try({
    source(f)
    t <- list(content_raw = "<html></html>")
    class(t) <- classify(x)
    pb_deliver_paper(t, verbose = FALSE, pb = NULL)
  })
  !methods::is(test, "try-error")
}

edit_parser <- function(f) {
  if (rlang::is_installed("rstudioapi")) {
    rstudioapi::documentOpen(f)
  } else {
    utils::file.edit(f)
  }
}
