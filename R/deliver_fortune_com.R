#' @export
pb_deliver_paper.fortune_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_ld <- html %>%
    rvest::html_element("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON()

  # datetime
  datetime <- json_ld$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("[name=\"author\"]") %>%
    rvest::html_attr("content") %>%
    toString()

  if (is.na(author) || author == "NA") {
    author <- json_ld$author$name %>%
      toString()
  }

  # text
  intro <- html %>%
    rvest::html_elements("article.article-content > p") %>%
    rvest::html_text2()

  body <- html %>%
    rvest::html_elements("div.paywall > p") %>%
    rvest::html_text2()

  text <- c(intro, body) %>%
    .[!grepl("^The opinions expressed in Fortune\\.com", .)] %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
