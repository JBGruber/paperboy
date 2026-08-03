#' @export
pb_deliver_paper.huffpost_com <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_elements(
      ".headline__title,.headline__subtitle,.js-headline,.headline"
    ) %>%
    rvest::html_text() %>%
    paste0(collapse = ". ")

  # author
  author <- html %>%
    rvest::html_elements(
      "div.entry__byline__author a[data-vars-item-type=\"text\"]"
    ) %>%
    rvest::html_attr("data-vars-item-name") %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(".cli-text>p,.entry-video__content__description") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  content_type <- html %>%
    rvest::html_elements("[property=\"og:type\"]") %>%
    rvest::html_attr("content")

  content_type <- c(content_type, "unknown")[1]

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type
  )
}


# define aliases for pages using the same layout
pb_deliver_paper.huffingtonpost_com <-
  pb_deliver_paper.huffingtonpost_co_uk <-
    pb_deliver_paper.huffpost_com
