#' @export

pb_deliver_paper.latimes_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  
  json_ld <- html %>% 
    rvest::html_element('script[type="application/ld+json"]') %>% 
    rvest::html_text() %>% 
    jsonlite::fromJSON()

  # datetime
  datetime <- json_ld$datePublished %>%
    lubridate::as_datetime()
  
  # headline
  headline <- json_ld$headline

  # author
  author <- paste(json_ld$author$name, collapse = ", ")

  # text
  text <- json_ld$articleBody
  
  # date and time URL was accessed
  accessed <- Sys.time()

  s_n_list(
    datetime,
    author,
    headline,
    text,
    accessed
  )

}
