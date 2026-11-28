#' @export
pb_deliver_paper.queer_de <- function(x, verbose = NULL, pb, ...) {
  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(iconv(
    x$content_raw,
    from = "windows-1252",
    to = "UTF-8"
  ))

  # datetime
  date <- html %>%
    xml2::xml_find_all("//comment()") %>%
    xml2::xml_text() %>%
    stringr::str_extract("\\d{2}\\.\\d{2}\\.\\d{4}")
  time <- html %>%
    rvest::html_element("div.artikelextrakopf li") %>%
    rvest::html_text2() %>%
    stringr::str_extract("\\d{1,2}:\\d{2}(?=h)")
  datetime <- paste(date[!is.na(date)][1], time) %>%
    lubridate::dmy_hm(tz = "Europe/Berlin", quiet = TRUE) %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    html_search(
      selectors = c("[property='og:title']", "div.artikelhead h1"),
      attributes = c("content", "text")
    )

  # author
  paragraphs <- html %>%
    rvest::html_elements(
      "div.artikelhead p.articlelead, div.content > p:not([class])"
    ) %>%
    rvest::html_text2()
  author <- paragraphs %>%
    stringr::str_extract("\\(([[:alpha:]]{1,6}/)*[[:alpha:]]{1,6}\\)\\s*$") %>%
    purrr::discard(is.na) %>%
    utils::tail(1L) %>%
    stringr::str_remove_all("[()\\s]") %>%
    stringr::str_replace_all("/", ", ") %>%
    toString()

  # text
  text <- paragraphs %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
