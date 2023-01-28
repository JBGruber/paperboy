pb_deliver_paper.www_cnet_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  if (is.na(datetime)) {
    datetime <- html %>%
      rvest::html_element("time") %>%
      rvest::html_text2() %>%
      lubridate::mdy() %>%
      as.POSIXct()
  }

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- html %>%
    rvest::html_elements(".c-globalAuthor_link,.author")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".c-CmsContent>p,.article-main-body>p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
