#' Collect data from supplied URLs
#'
#' @param urls Character object with URLs.
#' @param collect_rss If one of the URLs contains an RSS feed, should it be
#'   parsed.
#' @param timeout How long should the function wait for the connection (in
#'   seconds). If the query finishes earlier, results are returned immediately.
#' @param ignore_fails normally the function errors when a URL can't be reached
#'   due to connection issues. Setting to TRUE ignores this.
#' @param connections max total concurrent connections.
#' @param host_con max concurrent connections per host.
#' @param cookies list or vector of named cookie values.
#' @param useragent String to be sent in the User-Agent header.
#' @param save_dir store raw html data on disk instead of memory by providing a
#'   path to a directory.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen. If \code{NULL} will be determined from
#'   \code{getOption("paperboy_verbose")}.
#' @param ... Currently not used
#'
#' @return A data.frame (tibble) with url status data and raw media text.
#' @export
pb_collect <- function(urls,
                       collect_rss = TRUE,
                       timeout = 30,
                       ignore_fails = FALSE,
                       connections = 100L,
                       host_con = 6L,
                       cookies = list(),
                       useragent = "paperboy",
                       save_dir = NULL,
                       verbose = NULL,
                       ...) {

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  # prevent duplicates
  urls <- unique(urls)
  # not using the package env changes order of cli messages
  paperboy.env$len_unique <- length(urls)
  if (verbose) cli::cli_progress_step("{len_unique} unique URLs provided", .envir = paperboy.env)

  # it seems manual pagination is necessary as more than 1000 requests cause
  # 'Unrecoverable error in select/poll'
  url_batches <- split(urls, ceiling(seq_along(urls) / 1000))

  if (verbose) {
    oldstyle <- getOption("cli.spinner")
    options(cli.spinner = paperboy_spinner)
    cli::cli_progress_step("Fetching pages...", spinner = TRUE, .envir = paperboy.env)
  }

  res <- purrr::map(url_batches, function(b) {
    rp <- callr::r_bg(async_requests,
                      args = list(
                        urls = b,
                        ignore_fails = ignore_fails,
                        connections = connections,
                        host_con = host_con,
                        cookies = cookies,
                        useragent = useragent,
                        timeout = timeout,
                        save_dir = save_dir
                      ),
                      package = TRUE)
    while (rp$is_alive()) {
      if (verbose) cli::cli_progress_update(.envir = paperboy.env)
      Sys.sleep(2/100)
    }

    rp$get_result()
  })

  if (verbose) {
    cli::cli_progress_done(.envir = paperboy.env)
    options(cli.spinner = oldstyle)
  }

  status <- purrr::map(res, `[[`, 1L)
  if (sum(status[["1"]][["pending"]]) > 0) cli::cli_warn(paste(
    "{sum(status[['1']][['pending']])} download{?s} did not finish before timeout.",
    "Think about increasing the timeout parameter.",
    "See {.help [{.fun pb_collect}](paperboy::pb_collect)} for help."
  ))

  out <- purrr::list_rbind(purrr::map(res, `[[`, 2L))

  if (nrow(out) > 0) {

    out <- tibble::add_column(
      out,
      domain = urltools::domain(out$expanded_url),
      .after = "expanded_url"
    ) %>%
      dplyr::rename(url = urls)

    if (collect_rss) {
      rss <- grepl("<rss.+>", out$content_raw, useBytes = TRUE)
      if (any(rss)) {
        if (verbose) cli::cli_progress_step("Parsing RSS feeds")
        rss_out <- collect_rss(
          out[rss, ],
          collect_rss = FALSE,
          timeout = timeout,
          ignore_fails = ignore_fails,
          connections = connections,
          host_con = host_con,
          cookies = cookies,
          useragent = useragent,
          verbose = FALSE,
          ...
        )
        out <- dplyr::bind_rows(out[!rss, ], rss_out)
      }
    }

    # see issue #3
    if (any(out$domain == "www.washingtonpost.com")) {
      if (any(grepl("gdpr-consent", out$expanded_url, fixed = TRUE, useBytes = TRUE))) {
        cli::cli_alert_warning(c(
          "www.washingtonpost.com requests GDPR consent instead of showing",
                " the article. See {.url https://github.com/JBGruber/paperboy/issues/3}"
        ))
      }
    }

    if (verbose) {
      cli::cli_progress_step("{nrow(out)} page{?s} from {length(unique(out$domain))} domain{?s} collected.")
      cli::cli_progress_step("{cli::no(sum(out$status != 200L))} link{?s} had issues.")
    }
  }
  if (verbose) cli::cli_progress_done()
  attr(out, "paperboy_collected_at") <- Sys.time()
  attr(out, "paperboy_data_loc") <- ifelse(is.null(save_dir), "memory", "disk")

  return(out)
}


# setup handle (copied from
# https://github.com/r-lib/httr/blob/main/R/cookies.r)
pb_handle <- function(url, cookies, useragent) {
  if (is.null(names(cookies)) && length(cookies) > 0) {
    stop("cookies must be provided in name = value pairs.",
         " For example, cookies = list(a = 1, b = 2)")
  }
  # for sending only correct cookies, not yet used
  domain <- urltools::domain(url)
  cookies_str <- vapply(cookies, curl::curl_escape, FUN.VALUE = character(1))

  cookie <- paste(names(cookies), cookies_str, sep = "=", collapse = ";")

  curl::handle_setopt(
    curl::new_handle(),
    cookie = cookie,
    useragent = useragent
  )
}

# running async curl calls
async_requests <- function(urls,
                           ignore_fails,
                           connections,
                           host_con,
                           cookies,
                           useragent,
                           timeout,
                           save_dir) {

  pool <- curl::new_pool(total_con = connections,
                         host_con = host_con)

  paperboy.env$pages <- list()
  paperboy.env$ignore_fails <- ignore_fails

  if (is.null(save_dir)) {
    response_parser <- lapply(urls, parse_response)
  } else {
    if (!dir.exists(save_dir))
      cli::cli_abort("{.code save_dir} {.path {save_dir}} does not exist")
    response_parser <- lapply(urls, parse_response_disk, save_dir)
  }

  names(response_parser) <- urls
  fail_parser <- lapply(urls, parse_fail)
  names(fail_parser) <- urls

  invisible(lapply(urls, function(u) {
    curl::curl_fetch_multi(
      u,
      done = response_parser[[u]],
      fail = fail_parser[[u]],
      pool = pool,
      handle = pb_handle(u, cookies, useragent)
    )
  }))

  status <- curl::multi_run(timeout = timeout, pool = pool)
  pages <- dplyr::bind_rows(paperboy.env$pages, .id = "urls")
  list(status, pages)
}


parse_response <- function(url) {
  function(req) {
    paperboy.env$pages[[url]] <- list(
      expanded_url = req$url,
      status = req$status_code,
      content_raw = readBin(req$content, character())
    )
  }
}


parse_response_disk <- function(url, save_dir) {
  function(req) {
    f <- file.path(save_dir, paste0(rlang::hash(url), ".html"))
    writeBin(req$content, con = f, useBytes = TRUE)
    paperboy.env$pages[[url]] <- list(
      expanded_url = req$url,
      status = req$status_code,
      content_raw = f
    )
  }
}


parse_fail <- function(url) {
  function(req, i_f = paperboy.env$ignore_fails) {
    if (i_f) {
      paperboy.env$pages[[url]] <- list(
        expanded_url = "connection error",
        status = 503L,
        content_raw = NA
      )
    } else {
      cli::cli_abort("Connection error. Set {.code ignore_fails = TRUE} to ignore.")
    }
  }
}


collect_rss <- function(x, ...) {

  links <- x$content_raw %>%
    xml2::read_xml() %>%
    xml2::xml_find_all("//*[name()='item']") %>%
    xml2::as_list() %>%
    purrr::map("link") %>%
    unlist()

  pb_collect(links, ...)
}
