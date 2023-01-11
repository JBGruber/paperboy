pb_deliver_paper.{{newspaper}} <- function(x, verbose = NULL, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(html)
  if (verbose) pb$tick()

  # datetime
  datetime <- html %>%
    rvest::html_element("") %>%
    rvest::html_attr("") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("") %>%
    rvest::html_attr("")

  # author
  author <- html %>%
    rvest::html_element("")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_element("") %>%
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
