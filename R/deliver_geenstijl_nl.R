#' @export
pb_deliver_paper.geenstijl_nl <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_data <- html %>%
    rvest::html_element("script[type='application/ld+json']") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON()
  
  # datetime
  datetime <- json_data$datePublished %>% 
    lubridate::ymd_hms()
  
  # headline
  headline <- json_data$headline
  
  # author
  author <- json_data$author$name
  
  # text
  text <- html %>%
    rvest::html_elements("main p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")
  
  cover_image_html <- html %>%
    rvest::html_element("main img") %>%
    as.character()
  
  cover_image_url <- json_data$image

  cover_image_url <- html %>%
    rvest::html_element("article img") %>%
    rvest::html_attr("src")

  # date and time URL was accessed
  accessed <- Sys.time()
  
  # the helper function safely creates a named list from objects
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
