#' @export
pb_deliver_paper.cbsnews_com <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  scripts <- html %>%
    rvest::html_elements("script[type='application/ld+json']") %>%
    rvest::html_text()

  json <- scripts[grepl("NewsArticle", scripts)] %>%
    jsonlite::fromJSON()

  # datetime
  datetime <- json$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- json$headline

  # author
  author <- json$author$name

  # text
  text <- html %>%
    rvest::html_element(
      "article section.content-updating-story__content-wrapper, section.content__body"
    ) %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    stringr::str_trim() %>%
    paste(collapse = "\n")

  # content type
  content_type <- x$expanded_url %>%
    gsub(".*cbsnews.com/(.+?)/.*", "\\1", ., perl = TRUE)

  # date and time of scraping
  accessed = Sys.time()

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type,
    accessed
  )
}
