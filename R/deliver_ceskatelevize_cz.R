pb_deliver_paper.ceskatelevize_cz <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[type=\"application/json\"]") %>%
    rvest::html_text() %>%
    extract("(?<=\"startsAt\":\")\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_element("[name=\"author\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  if (author == "NA") {
    author <- html %>%
      rvest::html_element(".article-meta__authors")  %>%
      rvest::html_text() %>%
      trimws()
  }

  # text
  text <- html %>%
    rvest::html_elements(".article__content p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("main img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("main img") %>%
    rvest::html_attr("src")

  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}
