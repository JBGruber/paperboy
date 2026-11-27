#' @export
pb_deliver_paper.dw_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  html <- rvest::read_html(x$content_raw)

  json_ld <- html %>%
    rvest::html_element("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON()

  # datetime
  datetime <- html %>%
    html_search(
      selectors = c("[name=\"date\"]"),
      attributes = c("content")
    )
  if (!is.null(json_ld$datePublished)) datetime <- json_ld$datePublished
  datetime <- lubridate::as_datetime(datetime)

  # headline
  headline <- html %>%
    html_search(
      selectors = c("[property=\"og:title\"]", "h1"),
      attributes = c("content", "text")
    ) %>%
    trimws()

  # author
  author <- json_ld$author$name
  if (length(author) == 0) {
    author <- html %>%
      rvest::html_element(".author-details") %>%
      rvest::html_text2()
  }
  author <- toString(trimws(gsub("\\s+", " ", author)))

  # text
  text <- html %>%
    html_search(
      selectors = c(".rich-text > p", "article p"),
      attributes = c("text"),
      n = Inf
    ) %>%
    .[!grepl("^To (view|play) this (video|audio) please enable JavaScript", .)] %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
