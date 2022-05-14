#' @title Deliver online news articles
#'
#' @description This function will determine the website of the urls given to it
#'   and call the appropriate webscraper.
#'
#' @param x Either a vector of URLs or a data.frame returned by
#'   \link{pb_collect}.
#' @param verbose A logical flag indicating whether information should be
#'   printed to the screen. If \code{NULL} will be determined from
#'   \code{getOption("paperboy_verbose")}.
#' @param ... Passed on to respective scraper.
#'
#' @return A data.frame (tibble) with media data and full text.
#' @export
pb_deliver <- function(x, verbose = NULL, ...) {
  UseMethod("pb_deliver")
}

#' @export
pb_deliver.default <- function(x, verbose = NULL, ...) {
    stop("No method for class ", class(x), ".")
}

#' @export
pb_deliver.character <- function(x, verbose = NULL, ...) {

  pages <- pb_collect(x, verbose = verbose)

  pb_deliver(pages, verbose = verbose, ...)

}

#' @export
pb_deliver.data.frame <- function(x, verbose = NULL, ...) {

  if (!"content_raw" %in% colnames(x)) {
    stop("x must be a character vector of URLs or a data.frame",
         " returned by pb_collect.")
  }

  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  bad_status <- x$status != 200L
  x <- x[!bad_status, ]

  if (verbose) {
    if (sum(bad_status) > 0) {
      message(sum(bad_status), " URLs removed due to bad status.", appendLF = FALSE)
    }
    if (sum(!bad_status) > 0) {
      message(" Parsing...")
    }
  }

  domains <- split(x, x$domain, drop = TRUE)

  out <- lapply(domains, function(u) {

    class(u) <- c(
      gsub(".", "_", utils::head(u$domain, 1), fixed = TRUE),
      class(u)
    )

    pb_deliver_paper(u, verbose = verbose, ...)

  })

  return(dplyr::bind_rows(out))

}

#' internal function to deliver specific newspapers
#' @param x A data.frame returned by  \link{pb_collect} with an additional class
#'   indicating the domain of all links.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper <- function(x, verbose = NULL, ...) {
  UseMethod("pb_deliver_paper")
}

pb_deliver_paper.default <- function(x, verbose = NULL, ...) {
  warning("No method for ", x$domain[1], " yet. Url ignored.")
  NULL
}

# used for testing
pb_deliver_paper.httpbin_org <- function(...) {

}
