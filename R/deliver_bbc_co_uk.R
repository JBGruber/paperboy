pb_deliver_paper.bbc_co_uk <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element("[class*=\"TextContributorName\"]")  %>%
    rvest::html_text2() %>%
    stats::na.omit() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article [class*=\"RichText\"],article .story-body") %>%
    rvest::html_elements("p,li") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element("picture img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("picture img") %>%
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
