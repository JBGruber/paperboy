pb_deliver_paper.irishtimes_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text2() %>%
    lapply(jsonlite::fromJSON)

  # usually there are more than one,
  if (length(data) > 1L) {
    tp <- purrr::map_chr(data, function(x)
      purrr::pluck(x, "@type", .default = NA_character_))

    data <- purrr::pluck(data, which(tp == "NewsArticle"), .default = NA)
  }

  if (!isTRUE(is.na(data))) {

    # datetime
    datetime <- data$datePublished %>%
      lubridate::as_datetime()

    # headline
    headline <- data$headline

    # author
    author <- data$author$name %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements("article p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    cover_image_url <- purrr::pluck(data$image, 1, .default = NA)

    type <- data$`@type`

    s_n_list(
      datetime,
      author,
      headline,
      text,
      type,
      cover_image_url
    )
  } else {
    s_n_list()
  }

}
