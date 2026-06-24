#' @export

pb_deliver_paper.newsweek_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  json_txt <- rvest::html_elements(html, "script[type=\"application/ld+json\"]") %>% rvest::html_text()
  json_data <- if (length(json_txt) > 0) jsonlite::fromJSON(json_txt[1], simplifyVector = FALSE) else list()
  news_article <- Filter(function(x) identical(x[["@type"]], "NewsArticle"), json_data)
  news_article <- if (length(news_article) > 0) news_article[[1]] else list()

  # datetime
  datetime <- lubridate::as_datetime(news_article$datePublished)

  # headline
  headline <- html %>%
    rvest::html_elements("[property =\"og:title\"]") %>%
    rvest::html_attr("content")

  # author
  author <- toString(vapply(news_article$author, function(a) a$name %||% "", character(1)))

  # text
  text <- html %>%
    rvest::html_elements(xpath = "//article[contains(@class,'articleBody')]//p[not(ancestor::blockquote[contains(@class,'blockQuote')])]") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
