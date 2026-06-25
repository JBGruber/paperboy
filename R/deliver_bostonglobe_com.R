#' @export
pb_deliver_paper.bostonglobe_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[name="datePublished"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content") %>%
    sub(" - The Boston Globe$", "", .)

  # author
  author <- tryCatch({
    json <- html %>%
      rvest::html_element('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()
    paste(json$author$name, collapse = ", ")
  }, error = function(e) NA_character_) %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("div.body > p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
