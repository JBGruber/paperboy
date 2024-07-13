#' @export
pb_deliver_paper.metronieuws_nl <- function(x, verbose = NULL, pb, ...) {

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
    rvest::html_element(".article__title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_elements("[name=\"author\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article__content>p,.article__content>h2:not(.coral-talk-heading)") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")



  cover_image_html <- html %>%
    rvest::html_element(".featured-image img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".featured-image img") %>%
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
