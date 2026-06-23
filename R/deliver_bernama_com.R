#' @export
pb_deliver_paper.bernama_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::parse_date_time(orders = c("dmy IMp", "ymd HMS"))

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
    rvest::html_elements(".col-lg-8 .col-12.mt-3.text-dark.text-justify p") %>%
    rvest::html_text2() %>%
    .[!grepl("^--\\s|^BERNAMA provides", .)] %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
