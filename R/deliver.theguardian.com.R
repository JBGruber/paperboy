#' @rdname deliver
#' @export
deliver.www_theguardian_com <- function(url, verbose = TRUE, ...) {

  if (!"tbl_df" %in% class(url))
    stop("Wrong object passed to internal deliver function: ", class(url))

  if (verbose) message("\t...fetching theguardian.com articles")

  pb <- make_pb(url)

  purrr::map_df(url$expanded_url, function(u) {

    if (verbose) pb$tick()

    html <- rvest::read_html(u)

    # datetime
    datetime <- html %>%
      rvest::html_elements("[property=\"article:published_time\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime()

    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements("[property=\"article:author\"]") %>%
      rvest::html_attr("content")

    if (length(author) == 0) {
      author <- html %>%
        rvest::html_elements("[name=\"author\"]") %>%
        rvest::html_attr("content")
    }

    if (length(author) > 1) author <- toString(author)

    # text
    text <- html %>%
      rvest::html_elements("p") %>%
      rvest::html_text() %>%
      paste(collapse = "\n\n")

    tibble::tibble(
      datetime,
      author,
      headline,
      text
    )
  }) %>%
    cbind(url) %>%
    normalise_df() %>%
    return()
}
