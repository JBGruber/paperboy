pb_deliver_paper.anotherangryvoice_blogspot_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element(".published") %>%
    rvest::html_attr("title") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element(".entry-title") %>%
    rvest::html_text() %>%
    trimws()

  # author
  author <- html %>%
    rvest::html_element(".fn")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_element(".entry-content") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # in-text links
  text_links <- html %>%
    rvest::html_elements(".entry-content>span>a") %>%
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
