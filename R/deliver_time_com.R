#' @export
pb_deliver_paper.time_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("meta[name=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("meta[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("meta[name=\"author\"]")  %>%
    rvest::html_attr("content")
  if (is.na(author)) {
    author <- html %>%
      rvest::html_element("[type=\"application/ld+json\"]") %>%
      rvest::html_text() %>%
      jsonlite::fromJSON() %>%
      purrr::pluck("creator", 1, .default = NA_character_)
  }
  author <- toString(author)

  # text
  text <- html %>%
    rvest::html_elements("article p") %>%
    rvest::html_text2()
  text <- text[nzchar(text) & text != "Advertisement"] %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
