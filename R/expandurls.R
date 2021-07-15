#' Expand URLs
#'
#' @param url Character object with URLs.
#' @param timeout How long should the function wait for the connection (in
#'   seconds). If the query finishes earlier, results are returned immediately.
#' @param ignore_fails normally the function errors when a url can't be reached
#'   due to connection issues. Setting to TRUE ignores this.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen.
#' @param ... Currently not used
#'
#' @return Character object with full (i.e., unshortened) URLs.
#' @export
#'
#' @importFrom rlang :=
expandurls <- function(url,
                       timeout = 15,
                       ignore_fails = FALSE,
                       verbose = FALSE,
                       ...) {

  # prevent duplicates
  url <- unique(url)

  # setup for async curl call
  pool <- curl::new_pool()
  pages <- list()

  # create different parser function for each request to identify results
  parse_response <- function(url) {
    function(req) {
      pages[[url]] <<- tibble::tibble(
        expanded_url = req$url,
        status = req$status_code
      )
    }
  }
  response_parser <- lapply(url, parse_response)
  names(response_parser) <- url

  parse_fail <- function(req, i_f = ignore_fails) {
    if (i_f) {
      pages[[req$url]] <<- tibble::tibble(
        expanded_url = "connection error",
        status = 503L
      )
      return(req)
    } else {
      stop("Connection error. Set `ignore_fails = TRUE` to ignore.")
    }
  }

  invisible(lapply(
    url, function(u) {
      curl::curl_fetch_multi(
        u,
        done = response_parser[[u]],
        fail = parse_fail,
        pool = pool
      )
    }
  ))
  status <- curl::multi_run(timeout = timeout, pool = pool)

  if (status$pending > 0) warning(
    status$pending,
    " job(s) did not finish before timeout. ",
    "Think about increasing the timeout parameter. ",
    "Enter ?expandurls for help."
  )

  out <- dplyr::bind_rows(pages, .id = "url")

  if (nrow(out) > 0) {
    out <- tibble::add_column(
      out,
      domain = urltools::domain(out$expanded_url),
      .after = "expanded_url"
    )
  }

  if (verbose) message(length(url),
                       " links from ",
                       length(unique(out$domain)),
                       " domains unshortened. Fetching...")

  return(out)
}
