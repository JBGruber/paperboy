#' @title Deliver online news articles
#'
#' @description This function will determine the website of the urls given to it
#'   and call the appropriate webscraper.
#'
#' @param x Either a vector of URLs or a data.frame returned by
#'   \link{pb_collect}.
#' @param verbose \code{FALSE} turns deliver silent. \code{TRUE} prints status
#'   messages and a progress bar on the screen. \code{2L} turns on debug mode.
#'   If \code{NULL} will be determined from
#'   \code{getOption("paperboy_verbose")}.
#' @param ... Passed on to \link{pb_collect}.
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

  pages <- pb_collect(x, verbose = verbose, ...)

  pb_deliver(pages, verbose = verbose)

}

#' @export
pb_deliver.data.frame <- function(x, verbose = NULL, ...) {

  if (!"content_raw" %in% colnames(x)) {
    cli::cli_abort(paste("x must be a character vector of URLs or a data.frame",
                         " returned by {.help [{.fun pb_collect}](paperboy::pb_collect)}."))
  }

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  bad_status <- x$status != 200L
  x <- x[!bad_status, ]

  if (verbose && sum(bad_status) > 0)
    cli::cli_progress_step("{sum(bad_status)} URL{?s} removed due to bad status.")

  domains <- split(x, x$domain, drop = TRUE)

  pb <- NULL
  if (verbose) {
    oldstyle <- getOption("cli.progress_bar_style")
    options(cli.progress_bar_style = list(
      current = cli::col_yellow("c"),
      complete = cli::col_grey("-"),
      incomplete = cli::col_grey("o")
    ))
    pb <- cli::cli_progress_bar("Parsing raw html:", total = nrow(x))
  }


  out <- purrr::list_rbind(purrr::map(domains, function(u) {

    class(u) <- c(
      classify(utils::head(u$domain, 1)),
      class(u)
    )


    out <- purrr::list_rbind(purrr::map(seq_along(u$url), function(i)
      pb_deliver_paper(x = u[i, ], verbose, pb)))
    return(out)
  }))

  if (verbose) {
    cli::cli_progress_done()
    options(cli.progress_bar_style = oldstyle)
  }

  return(normalise_df(out))
}

#' internal function to deliver specific newspapers
#' @param pb a progress bar object.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper <- function(x, verbose, pb, ...) {
  UseMethod("pb_deliver_paper")
}
