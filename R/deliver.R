#' @title Deliver online news articles
#'
#' @description This function will determine the website of the urls given to it
#'   and call the appropriate webscraper.
#'
#' @param url The URL of the web article.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen.
#' @param ... Passed on to respective scraper.
#'
#' @return A data.frame (tibble) with media data and full text.
#' @export
deliver <- function(url, verbose = TRUE, ...) {
  UseMethod("deliver")
}

#' @rdname deliver
#' @export
deliver.default <- function(url, verbose = TRUE, ...) {
  if ("domain" %in% names(url)) {
    warning("No method for ", url$domain[1], " yet. Url ignored.")
    NULL
  } else {
    stop("No method for ", class(url), " yet.")
  }
}

#' @rdname deliver
#' @export
deliver.character <- function(url, verbose = TRUE, ...) {

  pages <- expandurls(url, verbose = verbose)

  pages <- split(pages, pages$domain, drop = TRUE)

  out <- lapply(pages, function(u) {
    class(u) <- c(
      gsub(".", "_", utils::head(u$domain, 1), fixed = TRUE),
      class(u)
    )
    deliver(u, verbose = verbose, ...)
  })

  return(dplyr::bind_rows(out))
}

#' @rdname deliver
#' @export
deliver.www_buzzfeed_com <- function(url, verbose = TRUE, ...) {
  return(normalise_df(url))
}

#' @rdname deliver
#' @export
deliver.www_forbes_com <- function(url, verbose = TRUE, ...) {
  return(normalise_df(url))
}
