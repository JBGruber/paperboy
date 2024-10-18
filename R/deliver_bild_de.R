#' @export
pb_deliver_paper.bild_de <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  datetime <- html %>%
      rvest::html_nodes("time.datetime, time.datetime--video datetime") %>%
      rvest::html_text() %>%
      lubridate::as_datetime(format = "%d.%m.%Y - %H:%M Uhr ")
  
  # headline
  headline <- html %>%
      rvest::html_nodes(".document-title__headline") %>%
      rvest::html_text()
  
  # author
  author <- html %>%
      rvest::html_nodes(".authors") %>%
      rvest::html_text() %>%
      toString()
  
  # text
  text <- html %>%
      rvest::html_nodes(".article-body") %>%
      rvest::html_text() %>%
      paste(collapse = "\n")

    # the helper function safely creates a named list from objects
  s_n_list(
      datetime,
      author,
      headline,
      text
  )

}