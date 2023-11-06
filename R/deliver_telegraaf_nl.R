pb_deliver_paper.telegraaf_nl <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("[name=\"title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element(".DetailBylineBlock__author")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".Article__intro,.DetailBodyBlocks p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element(".DetailArticleImage img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".DetailArticleImage img") %>%
    rvest::html_attr("src") %>%
    paste0("https://www.telegraaf.nl", .)

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
