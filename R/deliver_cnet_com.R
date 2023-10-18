pb_deliver_paper.cnet_com <- function(x, verbose = NULL, pb, ...) {

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)
  pb_tick(x, verbose, pb)

  # datetime
  datetime <- html %>%
    rvest::html_element("time") %>%
    rvest::html_attr("datetime") %>%
    lubridate::as_datetime()

  if (is.na(datetime)) {
    suppressWarnings(datetime <- html %>%
                       rvest::html_element("time") %>%
                       rvest::html_text2() %>%
                       lubridate::mdy() %>%
                       as.POSIXct())
  }

  if (is.na(datetime)) {
    data <- html %>%
      rvest::html_element("[type=\"application/ld+json\"]") %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()

    if (utils::hasName(data, "@graph")) {
      data <- data$`@graph`[1, ]
    }

    datetime <- data$datePublished %>%
      lubridate::as_datetime()

    # headline
    headline <- data$headline

    # author
    author <- data$author$name

  } else {
    # headline
    headline <- html %>%
      rvest::html_elements("[property=\"og:title\"]") %>%
      rvest::html_attr("content")

    # author
    author <- html %>%
      rvest::html_elements(".c-globalAuthor_link,.author")  %>%
      rvest::html_text2() %>%
      toString()
  }

  # text
  text <- html %>%
    rvest::html_elements(".c-CmsContent>p,.article-main-body>p,.c-pageArticle_body p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
