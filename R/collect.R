#' Collect data from supplied URLs
#'
#' @param url Character object with URLs.
#' @param timeout How long should the function wait for the connection (in
#'   seconds). If the query finishes earlier, results are returned immediately.
#' @param ignore_fails normally the function errors when a URL can't be reached
#'   due to connection issues. Setting to TRUE ignores this.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen.
#' @param ... Currently not used
#'
#' @return A data.frame (tibble) with url status data and raw media text.
#' @export
#'
#' @importFrom rlang :=
pb_collect <- function(url,
                       timeout = 30,
                       ignore_fails = FALSE,
                       verbose = FALSE,
                       ...) {

  # prevent duplicates
  url <- unique(url)

  if (verbose) message(length(url), " unique URLs provided...")

  # setup for async curl call
  pool <- curl::new_pool()
  pages <- list()

  # create different parser function for each request to identify results
  parse_response <- function(url) {
    function(req) {
      pages[[url]] <<- list(
        expanded_url = req$url,
        status = req$status_code,
        content = readBin(req$content, character())
      )
    }
  }

  parse_fail <- function(url) {
    function(req, i_f = ignore_fails) {
      if (i_f) {
        pages[[url]] <<- list(
          expanded_url = "connection error",
          status = 503L,
          content = NA
        )
      } else {
        stop("Connection error. Set `ignore_fails = TRUE` to ignore.")
      }
    }
  }

  response_parser <- lapply(url, parse_response)
  names(response_parser) <- url
  fail_parser <- lapply(url, parse_fail)
  names(fail_parser) <- url

  # setup async call
  invisible(lapply(
    url, function(u) {
      curl::curl_fetch_multi(
        u,
        done = response_parser[[u]],
        fail = fail_parser[[u]],
        pool = pool
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

  out <- dplyr::bind_rows(pages, .id = "url")

  if (nrow(out) > 0) {
    out <- tibble::add_column(
      out,
      domain = urltools::domain(out$expanded_url),
      .after = "expanded_url"
    )
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
