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

  # video
  media_raw <- html %>%
    rvest::html_elements(".art-full img,video")

  media_link <- media_raw  %>%
    rvest::html_attr("src") %>%
    gsub("^//", "http://", .) %>%
    as.list()

  media_alt <-  media_raw  %>%
    rvest::html_attr("alt")

  media <- tibble::tibble(media_alt, media_link)

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    media
  )

}
