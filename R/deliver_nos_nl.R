pb_deliver_paper.nos_nl <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"og:article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element(".NYlVB")  %>%
    rvest::html_text2() %>%
    stats::na.omit() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("#content .eHATPt>p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("#content button picture") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("#content button picture img") %>%
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
