#' @export
pb_deliver_paper.der_postillon_com <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)

  # get final url
  final_url <- x$content_raw %>%
    rvest::read_html() %>%
    rvest::html_element("body a") %>%
    rvest::html_attr("href")

  html <- rvest::read_html(final_url)

  # author
  author <- html %>%
    rvest::html_element("meta[property='article:author']") %>%
    rvest::html_attr("content")

  # headline
  headline <- html %>%
    rvest::html_element("meta[property='og:title']") %>%
    rvest::html_attr("content")

  # text
  text <- html %>%
    rvest::html_element("#post-body") %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    stringr::str_trim() %>%
    paste(collapse = "\n")

  # date
  datetime <- html %>%
    rvest::html_element("#Blog1 time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  # adjust author if applicable
  if (author == "Der Postillon") {
    author_tmp <- html %>%
      rvest::html_element(
        "div[id='post-body'] span[style='font-size: x-small;']"
      ) %>%
      rvest::html_text() %>%
      sub("; Erstver.*$", "", .) %>%
      stringr::str_remove("(?i);\\s*foto.*$")
    if (author_tmp != "") {
      author <- author_tmp
    }
  }

  # date and time accessed
  accessed <- Sys.time()

  s_n_list(
    datetime,
    author,
    headline,
    text,
    accessed
  )
}
