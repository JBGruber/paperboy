pb_deliver_paper.nypost_com <- function(x, verbose = NULL, pb, ...) {

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
    rvest::html_elements(".byline__author")  %>%
    rvest::html_text2() %>%
    toString() %>%
    gsub("By ", "", ., fixed = TRUE)

  # text
  text <- html %>%
    rvest::html_elements("[class*=\"content\"]>p,[class*=\"entry-content\"]>p") %>%
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

pb_deliver_paper.decider_com <-
  pb_deliver_paper.pagesix_com <-
  pb_deliver_paper.nypost_com
