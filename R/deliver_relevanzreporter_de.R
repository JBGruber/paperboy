#' @export
pb_deliver_paper.relevanzreporter_de <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    html_search(
      selectors = c("[property='article:published_time']", "time"),
      attributes = c("content", "datetime")
    ) %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    html_search(
      selectors = c("[property='og:title']", "h1"),
      attributes = c("content", "text")
    )

  # author
  author <- html %>%
    rvest::html_elements(xpath = paste0(
      "//li[contains(@class, 'contributor-item')]",
      "[.//div[contains(@class, 'contributor-item__title')][starts-with(normalize-space(.), 'Autor')]]",
      "//a[contains(@class, 'contributor-item__name')]"
    )) %>%
    rvest::html_text2() %>%
    unique() %>%
    toString()

  # text
  text <- html %>%
    rvest::html_elements(paste(
      ".brxe-post-excerpt.bold > p",
      "#preview-content > p",
      "#preview-content > h2",
      "#preview-content > h3",
      "#preview-content > h4",
      "#preview-content > h5",
      "#preview-content > ul",
      "#preview-content > ol",
      "#preview-content > blockquote",
      sep = ", "
    )) %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  # the helper function safely creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
