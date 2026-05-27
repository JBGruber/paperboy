#' @export
pb_deliver_paper.blesk_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # data about the article is nicely stored in a json string
  data <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text2() %>%
    lapply(jsonlite::fromJSON)

  # usually there are more than one,
  if (length(data) > 1L) {

    tp <- purrr::map_chr(data, function(x) {
      graph <- purrr::pluck(x, "@graph")
      if (is.null(graph)) return(NA_character_)
      if (is.data.frame(graph)) return(graph$`@type`[1])
      return(NA_character_)
    })

    data <- purrr::pluck(data, which(tp == "NewsArticle"), "@graph")
  }

  # date
  datetime <- data$datePublished[1] %>%
    lubridate::ymd_hms()

  headline <- data$headline[1]

  if (is.list(data$author) && !is.data.frame(data$author)) {
    author <- data$author[[1]]$name[1]
  } else if (is.data.frame(data$author)) {
    author <- data$author$name[1]
  } else {
    author <- NA
  }

  # text
  text <- html %>%
    rvest::html_elements("#article p,#article h2") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_url <- data$image$url[1]

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url
  )

}
