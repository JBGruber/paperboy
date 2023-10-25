pb_deliver_paper.blesk_cz <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # data about the article is nicely stored in a json string
  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    lapply(jsonlite::fromJSON)

  # usually there are more than one,
  if (length(data) > 1L) {
    tp <- purrr::map_chr(data, function(x)
      purrr::pluck(x, "@type", .default = NA_character_))

    data <- purrr::pluck(data, which(tp == "NewsArticle"))
  }

  datetime <- data$datePublished %>%
    lubridate::ymd_hm()

  headline <- data$headline

  author <- data$author$name %>%
    toString()

  # # datetime
  # datetime <- html %>%
  #   rvest::html_element("[property=\"article:published_time\"]") %>%
  #   rvest::html_attr("content") %>%
  #   lubridate::as_datetime()
  #
  # # headline
  # headline <- html %>%
  #   rvest::html_element("title") %>%
  #   rvest::html_text2()
  #
  # # author
  # author <- html %>%
  #   rvest::html_elements(".author-container")  %>%
  #   rvest::html_text2() %>%
  #   toString() %>%
  #   sub("Autor: ", "", ., fixed = TRUE)

  # text
  text <- html %>%
    rvest::html_elements("#article p,#article h2") %>%
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
