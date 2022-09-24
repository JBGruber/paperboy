#' internal function to deliver specific newspapers
#' @param x A data.frame returned by  \link{pb_collect} with an additional class
#'   indicating the domain of all links.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper.ftw_usatoday_com <- function(x, verbose = NULL, ...) {

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  class_test(x)

  if (verbose) message("\t...", nrow(x), " articles from ", x$domain[1])

  # helper function to make progress bar
  pb <- make_pb(x)

  # iterate over all URLs and normalise data.frame
  purrr::map_df(x$content_raw, parse_ftw_usatoday_com, verbose, pb) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()

}

# define parsing function to iterate over the URLs
parse_ftw_usatoday_com <- function(html, verbose, pb) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(html)
  if (verbose) pb$tick()

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element(".author")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".articleBody") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}

