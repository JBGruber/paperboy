#' @export
pb_deliver_paper.parlamentnilisty_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(charToRaw(enc2utf8(x$content_raw)))

  # data about the article is nicely stored in a json string
  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    gsub("[\r\n]", "", .) %>% # sometimes uses illegal line breaks
    lapply(jsonlite::fromJSON, simplifyVector = FALSE)

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
  author <- purrr::pluck(data$author, "name", .default = NA_character_) %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article .article-content>p,article .brief") %>%
    rvest::html_elements(":not(style)") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_url <- purrr::pluck(data, "image", "url", .default = NA_character_)
  if (!is.na(cover_image_url)) {
    cover_image_url <- gsub("amp;", "", cover_image_url, fixed = TRUE)
  }

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url
  )

}
