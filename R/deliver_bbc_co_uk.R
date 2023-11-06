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
    rvest::html_elements("article [class*=\"RichText\"] p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
