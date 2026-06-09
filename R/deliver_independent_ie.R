#' @export
pb_deliver_paper.independent_ie <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  
  json_data <- html %>%
    rvest::html_elements("script[type='application/ld+json']") %>%
    rvest::html_text() %>%
    purrr::keep(~ grepl('"NewsArticle"', .x)) %>%
    purrr::pluck(1) %>%
    jsonlite::fromJSON()
  
  # datetime
  datetime <- json_data$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- json_data$headline

  # author
  author <- html %>%
    rvest::html_elements("[class*='author'], [data-testid*='author']") %>%
    rvest::html_text2() %>%
    purrr::pluck(1)  %>%
    strsplit("\n") %>%
    purrr::pluck(1, 1)
  
  # text
  text <- html %>%
    rvest::html_elements("article p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <-  html %>%
    rvest::html_element("article img") %>%
    as.character()

  cover_image_url <- json_data$image[1]
  
  # date and time URL was accessed
  accessed <- Sys.time()

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html,
    accessed
  )

}
