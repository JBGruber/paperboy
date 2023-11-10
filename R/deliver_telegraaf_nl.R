pb_deliver_paper.telegraaf_nl <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  data <- html %>%
    rvest::html_elements("[data-name=\"PageTracking\"]") %>%
    rvest::html_text2() %>%
    jsonlite::fromJSON()

  type <- purrr::pluck(data, "article", "type")
  paywall <- purrr::pluck(data, "article", "premium")

  # datetime
  datetime <- purrr::pluck(data, "article", "publishDate") %>%
    lubridate::as_datetime()

  # headline
  headline <- purrr::pluck(data, "article", "title")

  # author
  author <- purrr::pluck(data, "article", "author", .default = NA_character_)

  # text
  if (type == "normal") {
    text <- html %>%
      rvest::html_elements(".Article__intro,.DetailBodyBlocks p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
  } else {
    text <- paste0("[", type, "]")
  }

  cover_image_html <- html %>%
    rvest::html_element(".DetailArticleImage img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".DetailArticleImage img") %>%
    rvest::html_attr("src")

  if (!is.na(cover_image_url))
    cover_image_url <- paste0("https://www.telegraaf.nl", cover_image_url)

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    type,
    paywall,
    cover_image_url,
    cover_image_html
  )

}
