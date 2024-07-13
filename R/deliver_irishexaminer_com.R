#' @export
pb_deliver_paper.irishexaminer_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element(".article-title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element(".author-byline")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("picture img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("picture img") %>%
    rvest::html_attr("src")

  if (!is.na(cover_image_url))
    cover_image_url <- paste0("https://www.irishexaminer.com", cover_image_url)

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
