#' @export
pb_deliver_paper.aktualne_cz <- function(x, verbose = NULL, pb, ...) {

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
    rvest::html_elements(".author__name")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article .article__perex,#article-content p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element(".article__photo--opener img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".article__photo--opener img") %>%
    rvest::html_attr("src")

  if (!is.na(cover_image_url)) {
    cover_image_url <- paste0("https:", cover_image_url)
  }

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
