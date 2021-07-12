#' @title Deliver online news articles
#'
#' @description This function will determine the website of the urls given to it
#'   and call the appropriate webscraper.
#'
#' @param url The URL of the web article.
#' @param ... Passed on to respective scraper.
#'
#' @return A data.frame (tibble) with media data and full text.
#' @export
deliver <- function(url, ...) {
  UseMethod("deliver")
}

#' @rdname deliver
#' @export
deliver.default <- function(url, ...) {
  if ("domain" %in% names(url)) {
    warning("No method for ", url$domain[1], " yet. Url ignored.")
    NULL
  } else {
    stop("No method for ", class(url), " yet.")
  }
}

#' @rdname deliver
#' @export
deliver.character <- function(url, ...) {

  pages <- expandurls(url)

  pages <- split(pages, pages$domain, drop = TRUE)

  out <- lapply(pages, function(u) {
    class(u) <- c(gsub(".", "_", u$domain, fixed = TRUE), class(u))
    deliver(u, ...)
  })

  return(dplyr::bind_rows(out))
}

#' @rdname deliver
#' @export
deliver.www_theguardian_com <- function(url, ...) {
  return(normalise_df(url))
}

#' @rdname deliver
#' @export
deliver.www_huffingtonpost_co_uk <- function(url, ...) {
  return(normalise_df(url))
}

#' @rdname deliver
#' @export
deliver.www_buzzfeed_com <- function(url, ...) {
  return(normalise_df(url))
}

#' @rdname deliver
#' @export
deliver.www_forbes_com <- function(url, ...) {
  return(normalise_df(url))
}
