#' @export
pb_deliver_paper.buzzfeed_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_ld <- html %>% 
    rvest::html_element('script[type="application/ld+json"]') %>% 
    rvest::html_text() %>% 
    jsonlite::fromJSON()
  
  if(!is.null(purrr::pluck(json_ld, "@graph"))){
    json_ld <- json_ld$`@graph`[1,] 
  }
  
  # datetime
  datetime <- json_ld$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- json_ld$headline

  # author
  author <- json_ld$author$name
  if(is.null(author)) {
    author <- json_ld$author[[1]]$name
  }

  # text
  text <- html |>
    rvest::html_elements(".embed-post p, .embed-post h2") |>
    rvest::html_text2() |>
    trimws() |>
    paste(collapse = "\n")

  # in-text links
  text_links <- html %>%
    rvest::html_elements(".subbuzz-text,.tweet__container") %>%
    rvest::html_elements("a") %>%
    rvest::html_attr("href") %>%
    as.list()
  
  if(length(text_links) == 0) {
    text <- NA_character_
  }
  
  # date and time URL was accessed
  accessed <- Sys.time()

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    text_links,
    accessed
  )

}
