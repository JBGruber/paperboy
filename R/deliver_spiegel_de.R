#' @export
pb_deliver.spiegel.de <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  datetime <- html %>%
      html_search(c("time"),c("datetime")) %>%
      lubridate::as_datetime()

  # headline
  headline <- html %>%
      rvest::html_nodes(".font-brandUI .align-middle") %>%
      rvest::html_text()

  if(length(headline) > 1) {
    headline <- headline[!grepl("\\n", headline)]
  }

  # author
  author <- html %>%
      rvest::html_nodes("header a.text-black") %>%
      rvest::html_text2() %>%
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