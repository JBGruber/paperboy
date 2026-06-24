#' @export
pb_deliver_paper.malaysiakini_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
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
  author <- html %>%
    rvest::html_element('[property="article:author"]') %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    html_search(c("div.px-4 > p", "p"), attributes = "text", n = Inf) %>%
    .[!grepl("WhatsApp Channel", ., fixed = TRUE)] %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
