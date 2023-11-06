pb_deliver_paper.breitbart_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text()

  # author
  author <- html %>%
    rvest::html_element("address")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".entry-content>p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # in-text links
  text_links <- html %>%
    rvest::html_elements(".entry-content>p>a") %>%
    rvest::html_attr("href") %>%
    as.list()

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    text_links
  )

}
