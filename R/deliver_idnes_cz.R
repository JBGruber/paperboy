#' @export
pb_deliver_paper.idnes_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  x$content_raw <- iconv(x$content_raw, from = "windows-1250", to = "UTF-8")
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element(".content h1") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element("[property=\"article:author\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".opener,.text p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_elements(".art-full img,video") %>%
    as.character() %>%
    paste(collapse = "\n")

  cover_image_url <- html %>%
    rvest::html_element(".art-full img,video") %>%
    rvest::html_attr("src") %>%
    paste0("https:", .)

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
