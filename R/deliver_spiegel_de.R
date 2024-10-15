#' @export
pb_deliver_paper.spiegel_de <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  datetime <- html %>%
      html_search(c("time"),c("datetime")) %>%
      lubridate::as_datetime()

  # headline
  headline <- html %>%
      rvest::html_element("article") %>%
      rvest::html_attr("aria-label")

  # author
  author <- html %>%
      rvest::html_element("meta[name=\"author\"]") %>%
      rvest::html_attr("content") %>%
      toString()

  # text
  text <- html %>%
      rvest::html_elements("div[data-area = \"body\"]") %>%
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
