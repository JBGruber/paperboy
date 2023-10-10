pb_deliver_paper.volkskrant_nl <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  # datetime
  datetime <- html %>%
    rvest::html_element("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    as.POSIXct(tz = "Europe/Amsterdam", "%Y-%m-%dT%H:%M")

  if (is.na(datetime)) {
    datetime <- html %>%
      rvest::html_element(".byline-date") %>%
      rvest::html_text2() %>%
      lubridate::dmy_hm()
  }

  # headline
  headline <- html %>%
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element(".authors,.artstyle__production__author")  %>%
    rvest::html_text2() %>%
    toString()

  # don't put NA in live tickers
  if (length(rvest::html_element(html, ".live-blog__moment__paragraph")) > 0) {
    author <- ""
  }

  # text
  text <- html %>%
    rvest::html_elements(".block-text p,.lead p,.artstyle__intro,.artstyle__paragraph,.live-blog__moment__paragraph") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  cover_image_html <- html %>%
    rvest::html_element(".visual .header-video,.artstyle__main img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element(".visual video,.artstyle__main img") %>%
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


pb_deliver_paper.www_volkskrant_nl <- pb_deliver_paper.volkskrant_nl
