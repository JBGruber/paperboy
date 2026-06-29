#' @export
pb_deliver_paper.decider_com <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_element('[property="article:published_time"]') %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    rvest::html_element('[property="og:title"]') %>%
    rvest::html_attr("content")

  # author
  author <- tryCatch({
    json <- html %>%
      rvest::html_element('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()
    toString(json$author$name)
  }, error = function(e) {
    html %>%
      html_search(c("span.story__meta__author", "[name=\"author\"]"),
                  c("text", "content")) %>%
      toString() %>%
      gsub("^By\\s", "", .)
  })

  # text
  text <- html %>%
    html_search(c("div.entry-content-read-more > p", "div.entry-content p", "p"),
                "text", all = FALSE) %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
