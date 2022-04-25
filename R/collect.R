#' Collect data from supplied URLs
#'
#' @param urls Character object with URLs.
#' @param timeout How long should the function wait for the connection (in
#'   seconds). If the query finishes earlier, results are returned immediately.
#' @param ignore_fails normally the function errors when a URL can't be reached
#'   due to connection issues. Setting to TRUE ignores this.
#' @param connections max total concurrent connections.
#' @param host_con max concurrent connections per host.
#' @param cookies list of named cookie values.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen. If \code{NULL} will be determined from
#'   \code{getOption("paperboy_verbose")}.
#' @param ... Currently not used
#'
#' @return A data.frame (tibble) with url status data and raw media text.
#' @export
#'
#' @importFrom rlang :=
pb_collect <- function(urls,
                       timeout = 30,
                       ignore_fails = FALSE,
                       connections = 100L,
                       host_con = 6L,
                       cookies = list(),
                       verbose = NULL,
                       ...) {

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  # prevent duplicates
  urls <- unique(urls)

  if (verbose) message(length(urls), " unique URLs provided...")

  # setup for async curl call
  pool <- curl::new_pool(total_con = connections,
                         host_con = host_con)
  pages <- list()

  # create different parser function for each request to identify results
  parse_response <- function(urls) {
    function(req) {
      pages[[urls]] <<- list(
        expanded_url = req$url,
        status = req$status_code,
        content_raw = readBin(req$content, character())
      )
    }
  }

  parse_fail <- function(urls) {
    function(req, i_f = ignore_fails) {
      if (i_f) {
        pages[[urls]] <<- list(
          expanded_url = "connection error",
          status = 503L,
          content_raw = NA
        )
      } else {
        stop("Connection error. Set `ignore_fails = TRUE` to ignore.")
      }
    }
  }

  response_parser <- lapply(urls, parse_response)
  names(response_parser) <- urls
  fail_parser <- lapply(urls, parse_fail)
  names(fail_parser) <- urls

  # setup handle (copied from https://github.com/r-lib/httr/blob/main/R/cookies.r)

  pb_handle <- function(cookies) {
    if (is.null(names(cookies)) & length(cookies) > 0) {
      stop("cookies must be provided in name = value pairs.",
           " For example, cookies = list(a = 1, b = 2)")
    }
    cookies_str <- vapply(cookies, curl::curl_escape, FUN.VALUE = character(1))

    cookie <- paste(names(cookies), cookies_str, sep = "=", collapse = ";")

    curl::handle_setopt(curl::new_handle(), cookie = cookie)
  }

  # setup async call
  invisible(lapply(
    urls, function(u) {
      curl::curl_fetch_multi(
        u,
        done = response_parser[[u]],
        fail = fail_parser[[u]],
        pool = pool,
        handle = pb_handle(cookies)
      )
    }
  ))

  if (verbose) message("\t...collecting")
  status <- curl::multi_run(timeout = timeout, pool = pool)

  if (status$pending > 0) warning(
    status$pending,
    " job(s) did not finish before timeout. ",
    "Think about increasing the timeout parameter. ",
    "Enter ?pb_collect for help."
  )

  out <- dplyr::bind_rows(pages, .id = "urls")

  if (nrow(out) > 0) {
    out <- tibble::add_column(
      out,
      domain = urltools::domain(out$expanded_url),
      .after = "expanded_url"
    ) %>%
      dplyr::rename(url = urls)
  }

  # see issue #3
  if (any(out$domain == "www.washingtonpost.com")) {
    if (any(grepl("gdpr-consent", out$expanded_url, fixed = TRUE))) {
      warning("www.washingtonpost.com requests GDPR consent instead of showing",
              " the article. See https://github.com/JBGruber/paperboy/issues/3")
    }
  }

  if (verbose) {
    if (any(out$status != 200L)) {
      msg <- paste0(
        " ",
        sum(out$status != 200L),
        " links had issues."
      )
    } else {
      msg <- ""
    }
    message(
      nrow(out),
      " pages from ",
      length(unique(out$domain)),
      " domains collected.",
      msg
    )
  }

  attr(out, "paperboy_collected_at") <- Sys.time()

  return(out)
}
