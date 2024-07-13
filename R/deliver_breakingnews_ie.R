#' @export
pb_deliver_paper.breakingnews_ie <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  data <- html %>%
    rvest::html_element("script") %>%
    rvest::html_text2()

  if (!isTRUE(is.na(data))) {
    data <- jsonlite::fromJSON(data)
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

    cover_image_url <- utils::head(data$image$url, 1L)

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

