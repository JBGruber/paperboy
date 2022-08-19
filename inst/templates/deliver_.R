#' internal function to deliver specific newspapers
#' @param x A data.frame returned by  \link{pb_collect} with an additional class
#'   indicating the domain of all links.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper.{{newspaper}} <- function(x, verbose = NULL, ...) {

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  # A small test to check if x is really a tibble.
  if (!"tbl_df" %in% class(x))
    stop("Wrong object passed to internal deliver function: ", class(x))

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  # helper function to make progress bar
  pb <- make_pb(x)

  # define parsing function iterate over the URLs
  parse_{{newspaper}} <- function(i) {

    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw[i])
    if (verbose) pb$tick()

    # datetime
    datetime <- html |>
      rvest::html_elements("") |>
      rvest::html_attr("") |>
      lubridate::as_datetime()

    # headline
    headline <- html |>
      rvest::html_elements("") |>
      rvest::html_attr("")

    # author
    author <- html |>
      rvest::html_elements("")  |>
      rvest::html_text2() |>
      toString()

    # text
    text <- html |>
      rvest::html_elements("") |>
      rvest::html_text2()

    # the helper function safely makes creates a named list from objects
    s_n_list(
      datetime,
      author,
      headline,
      text
    )

  }

  # iterate over all URLs and normalise data.frame
  purrr::map_df(seq_along(x$url), parse_) |>
    cbind(x) |>
    normalise_df() |>
    return()

}
