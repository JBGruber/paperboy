#' @export
pb_deliver_paper.abs_cbn_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # the article is delivered as JSON in the Next.js data blob
  data <- html %>%
    rvest::html_element("script#__NEXT_DATA__") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON(simplifyVector = FALSE) %>%
    purrr::pluck("props", "pageProps", "content", .default = list())

  # datetime
  datetime <- purrr::pluck(
    data, "firstpublished",
    .default = html_search(
      html,
      c("[property=\"article:published_time\"]", "[name=\"pubdate\"]"),
      "content",
      all = FALSE
    )
  ) %>%
    lubridate::as_datetime()

  # headline
  headline <- purrr::pluck(
    data, "headline",
    .default = html_search(html, "[property=\"og:title\"]", "content")
  )

  # author
  author <- purrr::map_chr(
    purrr::pluck(data, "authors", .default = list()),
    purrr::pluck, "name", .default = NA_character_
  )
  if (length(author) == 0L) {
    author <- html_search(html, "[name=\"author\"]", "content")
  }
  author <- toString(author)

  # text
  text <- purrr::pluck(data, "body_html", .default = "<p></p>") %>%
    rvest::read_html() %>%
    rvest::html_elements("p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
