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
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")

  # author
  json_txt <- rvest::html_elements(html, 'script[type="application/ld+json"]') %>%
    rvest::html_text()
  author <- tryCatch({
    json_df <- jsonlite::fromJSON(json_txt[1])
    toString(json_df$author$name)
  }, error = function(e) {
    html %>%
      rvest::html_elements("span.byline-name") %>%
      rvest::html_text2() %>%
      toString()
  })

  # text
  text <- html %>%
    rvest::html_elements('article[class*="article-wrapper"] p') %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
