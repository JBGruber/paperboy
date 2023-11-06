pb_deliver_paper.denikn_cz <- function(x, verbose = NULL, pb, ...) {

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
    rvest::html_element("title") %>%
    rvest::html_text2()

  # author
  author <- html %>%
    rvest::html_element(".e_author_t")  %>%
    rvest::html_text2() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements("article p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  paywall <- FALSE
  if (length(rvest::html_element(html, ".e_lock__hard"))) {
    text <- paste("[Paywall-Truncated]", text)
    paywall <- TRUE
  }

  cover_image_html <- html %>%
    rvest::html_element("header .b_single_i img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("header .b_single_i img") %>%
    rvest::html_attr("src")

  s_n_list(
    datetime,
    author,
    headline,
    text,
    paywall,
    cover_image_url,
    cover_image_html
  )

}
