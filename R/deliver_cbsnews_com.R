pb_deliver_paper.www_cbsnews_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_elements("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime() %>%
    head(1L)

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("[class*=\"content__meta--byline\"]") %>%
    rvest::html_text() %>%
    gsub("By\\b\\s+|\n", "", .) %>%
    trimws()

  # text
  text <- html %>%
    rvest::html_elements(".content__body>p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  content_type <- x$expanded_url %>%
    gsub(".*cbsnews.com/(.+?)/.*", "\\1", ., perl = TRUE)

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type
  )

}
