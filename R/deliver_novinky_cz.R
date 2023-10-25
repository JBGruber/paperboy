pb_deliver_paper.novinky_cz <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  page_data <- try({html %>%
    rvest::html_element(".page-detail script") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON()}, silent = TRUE)

  # datetime
  datetime <- purrr::pluck(page_data, "datePublished", .default = NA_character_) %>%
    lubridate::as_datetime()

  # headline
  headline <- purrr::pluck(page_data, "headline", .default = NA_character_)

  # author
  author <- purrr::pluck(page_data, "author", "name", .default = NA_character_) %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".j_if .speakable") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element(".ogm-main-media__container img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".ogm-main-media__container img") %>%
    rvest::html_attr("src") %>%
    paste0("https:", .)

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
