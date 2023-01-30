pb_deliver_paper.www_theguardian_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

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
    rvest::html_elements("[property=\"article:author\"],[name=\"author\"]") %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
