#' @export
pb_deliver_paper.rte_ie <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
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
    rvest::html_elements("[itemprop=\"author\"]>[itemprop=\"name\"]")  %>%
    rvest::html_attr("content") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".article-body p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  type <- html %>%
    rvest::html_element("[name=\"article-type\"]") %>%
    rvest::html_attr("content")

  cover_image_html <- html %>%
    rvest::html_element("#main-article-image img") %>%
    as.character()

  cover_image_url <- html %>%
    rvest::html_element("#main-article-image img") %>%
    rvest::html_attr("src")

  s_n_list(
    datetime,
    author,
    headline,
    text,
    type,
    cover_image_url,
    cover_image_html
  )

}
