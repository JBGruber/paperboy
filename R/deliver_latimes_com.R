#' @export

pb_deliver_paper.latimes_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

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
    rvest::html_elements(".authors")  %>%
    rvest::html_text() %>%
    toString() %>%
    gsub("\n", "", .) %>%
    gsub("By", "", ., fixed = TRUE) %>%
    trimws()

  # text
  text <- html %>%
    rvest::html_elements(".page-article-container>p,.rich-text-body>p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
