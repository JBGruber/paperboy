#' @export

pb_deliver_paper.foxbusiness_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[name=\"dcterms.created\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_elements(".author,.author-byline") %>%
    rvest::html_text2() %>%
    gsub("By ", "", ., fixed = TRUE) %>%
    trimws() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article-content") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}


pb_deliver_paper.foxnews_com <- pb_deliver_paper.foxbusiness_com

