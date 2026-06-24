#' @export
pb_deliver_paper.aftenposten_no <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)

  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element(".byline-name") %>%
    rvest::html_text2()

  # text
  text <- html %>%
    rvest::html_elements('article[class*="article-wrapper"]>p') %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
