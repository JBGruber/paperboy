#' @export
pb_deliver_paper.rtl_nl <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  if (is.na(datetime)) {
    datetime <- html %>%
      rvest::html_element("time") %>%
      rvest::html_attr("datetime") %>%
      lubridate::as_datetime()
  }

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("[data-testid=\"author\"]")  %>%
    rvest::html_text2() %>%
    toString() %>%
    # would be cleaner to remove the child, but not sure how
    gsub("\\..*", "", .)

  # text
  text <- html %>%
    rvest::html_elements("main p") %>%
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

pb_deliver_paper.rtlnieuws_nl <- pb_deliver_paper.rtl_nl
