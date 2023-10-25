pb_deliver_paper.ceskatelevize_cz <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # data about the article is nicely stored in a json string
  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    lapply(jsonlite::fromJSON)

  # usually there are more than one,
  if (length(data) > 0L) {
    tp <- purrr::map_chr(data, function(x)
      purrr::pluck(x, "@type", .default = NA_character_))

    data <- purrr::pluck(data, which(tp == "Article"))
  }

  # datetime
  datetime <- data$datePublished %>%
    lubridate::as_datetime()

  # headline
  headline <- data$headline

  # author
  author <- html %>%
    rvest::html_element("[name=\"author\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".textcontent p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_url <- data$image

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url
  )

}
