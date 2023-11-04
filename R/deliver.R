#' @title Deliver online news articles
#'
#' @description This function will determine the website of the urls given to it
#'   and call the appropriate webscraper.
#'
#' @param x Either a vector of URLs or a data.frame returned by
#'   \link{pb_collect}.
#' @param try_default if no parser is available, should a generic parser be used
#'   \code{TRUE} or should the URL be skipped \code{FALSE}?
#' @param verbose \code{FALSE} turns deliver silent. \code{TRUE} prints status
#'   messages and a progress bar on the screen. \code{2L} turns on debug mode.
#'   If \code{NULL} will be determined from
#'   \code{getOption("paperboy_verbose")}.
#' @param ... Passed on to \link{pb_collect}.
#'
#' @return A data.frame (tibble) with media data and full text.
#' @export
pb_deliver <- function(x, try_default = TRUE, verbose = NULL, ...) {
  UseMethod("pb_deliver")
}

#' @export
pb_deliver.default <- function(x, try_default = TRUE, verbose = NULL, ...) {
    stop("No method for class ", class(x), ".")
}

#' @export
pb_deliver.character <- function(x, try_default = TRUE, verbose = NULL, ...) {

  pages <- pb_collect(x, verbose = verbose, ...)

  pb_deliver(pages, try_default = try_default, verbose = verbose)

}

#' @export
pb_deliver.data.frame <- function(x, try_default = TRUE, verbose = NULL, ...) {

  if (!"content_raw" %in% colnames(x)) {
    cli::cli_abort(paste("x must be a character vector of URLs or a data.frame",
                         " returned by {.help [{.fun pb_collect}](paperboy::pb_collect)}."))
  }

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  bad_status <- x$status != 200L
  x <- x[!bad_status, ]

  if (isTRUE(verbose) && isTRUE(sum(bad_status) > 0))
    cli::cli_alert_warning("{sum(bad_status)} URL{?s} removed due to bad status.")

  if (!try_default) {
    sel <- pb_available(x$domain)
    x <- x[sel, ]
    if (isTRUE(verbose) && isTRUE(sum(!sel) > 0)) {
      cli::cli_alert_warning(c(
        "{sum(!sel)} URL{?s} removed as no parser is available for the domain{?s}. ",
        "Set {.fn try_default = TRUE} to try a generic parser for unknown domains."
      ))
    }
  }

  pb <- NULL
  if (verbose) {
    oldstyle <- getOption("cli.progress_bar_style")
    oldstyle_ascii <- getOption("cli.progress_bar_style_ascii")
    options(cli.progress_bar_style = list(
      current = cli::col_yellow("\u15E7"),
      complete = cli::col_grey("\u2010"),
      incomplete = cli::col_red("\u2022")
    ))
    options(cli.progress_bar_style_ascii = list(
      current = cli::col_yellow("C"),
      complete = cli::col_grey("-"),
      incomplete = cli::col_grey("o")
    ))
    pb <- cli::cli_progress_bar("Parsing raw html:", total = nrow(x))
  }

  x$class <- classify(x$domain)

  out <- purrr::list_rbind(purrr::map(purrr::transpose(x), function(r) {
    class(r) <- r$class
    cbind(
      r[c("url", "expanded_url", "domain", "status")],
      pb_deliver_paper(x = r, verbose, pb)
    )
  }))

  if (verbose) {
    cli::cli_progress_done()
    options(cli.progress_bar_style = oldstyle)
    options(cli.progress_bar_style_ascii = oldstyle_ascii)
  }

  # tell user about warnings
  ws <- mget(ls(inform_now_env), envir = inform_now_env)
  if (length(ws) > 0) {
    names(ws) <- rep("i", length(ws))
    for (w in ws) {
      cli::cli_alert_warning(w)
    }
    rm(list = ls(inform_now_env), envir = inform_now_env)
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
