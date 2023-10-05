
pb_deliver_paper.wsj_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

    # datetime
    datetime <- html %>%
      rvest::html_elements("[name=\"article.published\"]") %>%
      rvest::html_attr("content") %>%
      lubridate::as_datetime() %>%
      utils::head(1L)

    # headline
    headline <- html %>%
      rvest::html_elements("title") %>%
      rvest::html_text() %>%
      paste(collapse = "\n")

    # author
    author <- html %>%
      rvest::html_elements("[name=\"author\"]") %>%
      rvest::html_attr("content") %>%
      toString()

    # text
    text <- html %>%
      rvest::html_elements("p:not([id|=\"footer\"])") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")

    s_n_list(
      datetime,
      author,
      headline,
      text
    )

}
