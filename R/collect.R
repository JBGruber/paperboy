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
#' @param use_cookies If \code{TRUE}, use the \code{cookiemonster} package to
#'   handle cookies. See \link[cookiemonster]{add_cookies} for details on how to
#'   store cookies. Cookies are used to enter articles behind a paywall or
#'   consent form.
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
                       use_cookies = FALSE,
                       useragent = "paperboy",
                       save_dir = NULL,
                       mock = getOption("pb_mock", NULL),
                       verbose = NULL,
                       ...) {

  if (use_cookies) rlang::check_installed("cookiemonster")

  if ("cookies" %in% names(list(...))) {
    cli::cli_inform("The {.fn cookies} parameter is deprecated. Use {.fn use_cookies} instead.")
  }

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
    domain <- adaR::ada_get_domain(b[1])
    if (use_cookies) {
      cookies_str <- cookiemonster::get_cookies(paste0(domain, "\\b"), as = "string")
    } else {
      cookies_str <- NULL
    }
    rp <- callr::r_bg(async_requests,
                      args = list(
                        urls = b,
                        ignore_fails = ignore_fails,
                        connections = connections,
                        host_con = host_con,
                        cookies_str = cookies_str,
                        useragent = useragent,
                        timeout = timeout,
                        save_dir = save_dir,
                        mock = mock
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
      domain = adaR::ada_get_domain(out$expanded_url),
      .after = "expanded_url"
    )

    if (collect_rss) {

      if (!is.null(save_dir)) {
        cont <- unlist(lapply(out$content_raw, function(f) readChar(f, file.info(f)$size, useBytes = TRUE)))
      } else {
        cont <- out$content_raw
      }

      rss <- grepl("<rss.+>|<\\?xml.+>", cont, useBytes = TRUE)
      if (any(rss)) {
        if (verbose) cli::cli_progress_step("Parsing RSS feeds")
        cont <- cont[rss]
        class(cont) <- "html_content"
        rss_links <- pb_collect_rss(cont)
        rss_out <- pb_collect(
          rss_links,
          collect_rss = FALSE,
          timeout = timeout,
          ignore_fails = ignore_fails,
          connections = connections,
          host_con = host_con,
          use_cookies = use_cookies,
          useragent = useragent,
          save_dir = save_dir,
          mock = mock,
          verbose = FALSE,
          ...
        )
        out <- dplyr::bind_rows(out[!rss, ], rss_out)
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


pb_handle <- function(cookies_str, useragent) {
  h <- curl::new_handle()
  if (!is.null(cookies_str)) h <- curl::handle_setheaders(h, Cookie = cookies_str)
  curl::handle_setopt(h, useragent = useragent)
}

# running async curl calls
async_requests <- function(urls,
                           ignore_fails,
                           connections,
                           host_con,
                           cookies_str,
                           useragent,
                           timeout,
                           mock,
                           save_dir) {

  # strongly inspired by httr2
  # https://github.com/r-lib/httr2/blob/main/R/req-perform.R#L78-L84
  if (!is.null(mock)) {
    mock <- rlang::as_function(mock)
    mock_resp <- mock(urls)
    status <- list(success = length(urls),
                   error = 0,
                   pending = 0)
    return(list(status, mock_resp))
  }

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
      handle = pb_handle(cookies_str, useragent)
    )
  }))

  status <- curl::multi_run(timeout = timeout, pool = pool)
  pages <- dplyr::bind_rows(paperboy.env$pages, .id = "url")
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

