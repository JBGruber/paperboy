pb_deliver_paper.nytimes_com <- function(x, verbose, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    html_search(selectors = c(
      "[property=\"article:published_time\"]"
    ), attributes = "content") %>%
    lubridate::as_datetime()

  # author
  author <- html %>%
    rvest::html_elements("[name=\"byl\"]")  %>%
    rvest::html_attr("content") %>%
    toString() %>%
    gsub("By ", "", ., fixed = TRUE) %>%
    unique() %>%
    toString()

  if (!isFALSE(is.na(datetime))) {
    datetime <- html %>%
      rvest::html_elements("[slot=\"data\"],script") %>%
      rvest::html_text() %>%
      extract("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z") %>%
      unique() %>%
      lubridate::as_datetime() %>%
      utils::head(1L)
  }

  # headline
  headline <- html %>%
    rvest::html_elements("[property=\"og:title\"]") %>%
    rvest::html_attr("content")

  # text
  text_temp <- html %>%
    rvest::html_elements("[name=\"articleBody\"]")

  if (length(text_temp) > 0) {
    text <- text_temp %>%
      rvest::html_elements("p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
  } else {
    text <- html %>%
      rvest::html_elements("p") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
  }

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
