pb_deliver_paper.evolvepolitics_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element(".entry-date") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element(".tdb-title-text") %>%
    rvest::html_text()

  # author
  author <- html %>%
    rvest::html_element(".tdb-author-name")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".tdb-block-inner") %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # in-text links
  text_links <- html %>%
    rvest::html_elements(".tdb-block-inner") %>%
    rvest::html_elements("p>a") %>%
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
