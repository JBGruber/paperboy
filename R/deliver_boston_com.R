#' @export
pb_deliver_paper.boston_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element('[name="author"]') %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article.content-well > p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
