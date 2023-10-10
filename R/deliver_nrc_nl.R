pb_deliver_paper.nrc_nl <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  type <- NULL
  if (is.na(datetime)) {
    datetime <- html %>%
      rvest::html_element(".artikel") %>%
      rvest::html_attr("data-article-updated-at") %>%
      lubridate::as_datetime()

    type <- html %>%
      rvest::html_element(".artikel") %>%
      rvest::html_attr("data-article-type")
  }

  # headline
  headline <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  if (!is.null(type)) headline <- paste0("[", type, "] ", headline)

  # author
  author <- html %>%
    rvest::html_elements("[rel=\"author\"],.authors")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article__content>p,.article__content>.bericht>p,.podcast-content") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("picture img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("picture img") %>%
    rvest::html_attr("src")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    cover_image_url,
    cover_image_html
  )

}

pb_deliver_paper.www_nrc_nl <- pb_deliver_paper.nrc_nl
