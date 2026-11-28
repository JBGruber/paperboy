#' @export
pb_deliver_paper.op_online_de <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_txt <- html %>%
    rvest::html_elements("script[type='application/ld+json']") %>%
    rvest::html_text()
  json <- tryCatch(
    jsonlite::fromJSON(json_txt[1])$mainEntity,
    error = function(e) list()
  )

  # datetime
  datetime <- json$datePublished
  if (is.null(datetime)) {
    datetime <- html %>%
      rvest::html_element("time[datetime]") %>%
      rvest::html_attr("datetime")
  }
  datetime <- lubridate::as_datetime(datetime)

  # headline
  headline <- html %>%
    html_search(
      selectors = c("[property='og:title']", "h1.id-StoryElement-headline"),
      attributes = c("content", "text")
    )

  # author
  author <- html %>%
    rvest::html_elements(".id-Story-authors-link") %>%
    rvest::html_text2()
  if (length(author) == 0) {
    author <- json$author$name
  }
  author <- toString(unique(author))

  # text
  text <- html %>%
    rvest::html_elements(".id-StoryElement-leadText,.id-StoryElement-paragraph,.id-StoryElement-crosshead") %>%
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
