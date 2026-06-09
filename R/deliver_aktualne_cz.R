#' @export
pb_deliver_paper.aktualne_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  article <- html %>% 
    rvest::html_elements("script[type='application/ld+json']") %>% 
    rvest::html_text() %>% 
    purrr::keep(~ grepl('"NewsArticle"', .x)) %>% 
    purrr::pluck(1) %>% 
    jsonlite::fromJSON() %>% 
    purrr::pluck("@graph") %>% 
    {\(x) x[x$@type == "NewsArticle", ]}()
  
  # datetime
  datetime <- article$datePublished %>%
    lubridate::as_datetime()
 
  # headline
  headline <- article$headline
  
  # author
  author_json <- article$author[[1]]$name |> paste(collapse = ", ")
  author <-  if (is.null(author_json) || author_json == "") {
    html |>
      rvest::html_element("span.e-ui-authors-and-date__author-label") |>
      rvest::html_text2()
  } else {
    author_json
  }
  
  # text
  text <- html %>%
    rvest::html_element("div[class*='f-tiptap-content__root']") %>%
    rvest::html_elements("p, h2") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")
  
  # cover image html
  cover_image_html <- html %>%
    rvest::html_element("img.e-ui-image__img") %>%
    as.character()
  # cover image url 
  cover_image_url <- article$image$url
  
  # date and time URL was accessed
  accessed <- Sys.time()
  s_n_list(
    datetime,
    author,
    headline,
    text,
    accessed,
    cover_image_url,
    cover_image_html
  )
}