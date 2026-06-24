#' @export
pb_deliver_paper.malaymail_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_txt <- rvest::html_elements(html, 'script[type="application/ld+json"]') %>%
    rvest::html_text()
  json_df <- NULL
  for (j in json_txt) {
    parsed <- tryCatch(jsonlite::fromJSON(j), error = function(e) NULL)
    if (!is.null(parsed) && any(grepl("Article", parsed[["@type"]]))) {
      json_df <- parsed
      break
    }
  }

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")
  if (is.na(headline)) {
    headline <- html %>%
      rvest::html_element("h1.article-title") %>%
      rvest::html_text2()
  }

  # author
  author <- if (!is.null(json_df)) {
    toString(json_df$author$name)
  } else {
    html %>%
      rvest::html_element('[property="article:author"]') %>%
      rvest::html_attr("content") %>%
      toString()
  }

  # text
  text <- html %>%
    rvest::html_elements("div.article-body > p") %>%
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
