pb_deliver_paper.www_telegraph_co_uk <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    html_search("[itemprop=\"datePublished\"]",
                c("content", "datetime")) %>%
    as.POSIXct(format = "%Y-%m-%dT%H:%M%z") %>%
    utils::head(1L)

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_elements("[class*=\"byline__author\"]") %>%
    rvest::html_attr("content") %>%
    toString() %>%
    gsub("^By\\s", "", .)

  # text
  text <- html %>%
    rvest::html_elements("[class*=\"article-body-text\"]") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # type
  content_type <- html %>%
    rvest::html_element("[property=\"og:type\"]") %>%
    rvest::html_attr("content")

  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type
  )
}
