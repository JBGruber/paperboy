#' @export
pb_deliver_paper.tagesanzeiger_ch <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  page_data <- try({html %>%
      rvest::html_element("#page-data") %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()}, silent = TRUE)

  # datetime
  datetime <- paste(purrr::pluck(page_data, "articlePublicationDate", .default = NA_character_),
                    purrr::pluck(page_data, "articlePublicationTime", .default = NA_character_))%>%
    lubridate::as_datetime()

  # headline
  headline <- purrr::pluck(page_data, "articleTitle", .default = NA_character_)

  # author
  author <- purrr::pluck(page_data, "authorName", .default = NA_character_)

  # text
  text <- html %>%
    rvest::html_elements("#main > article p") %>%
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
