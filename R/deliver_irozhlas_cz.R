pb_deliver_paper.irozhlas_cz <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # data about the article is nicely stored in a json string
  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    lapply(jsonlite::fromJSON, simplifyVector = FALSE) %>%
    purrr::pluck(1L)

  # usually there are more than one,
  if (length(data) > 0L) {
    tp <- purrr::map_chr(data, function(x)
      purrr::pluck(x, "@type", .default = NA_character_))

    data <- purrr::pluck(data, which(tp == "NewsArticle"))
  }

  # datetime
  datetime <- data$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- data$headline

  # author
  author <- purrr::map_chr(data$author, "name") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article p:not(.meta):not([class*=\"b-audio-player\"])") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_url <- purrr::pluck(data, "image", "url", .default = NA_character_)

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url
  )

}
