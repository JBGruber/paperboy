#' @export
pb_deliver_paper.joe_ie <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  ld <- html %>%
    rvest::html_elements("[type=\"application/ld+json\"]") %>%
    rvest::html_text2() %>%
    lapply(jsonlite::fromJSON)

  graph <- purrr::detect(ld, function(d) {
    "NewsArticle" %in% purrr::pluck(d, "@graph", "@type", .default = character(0))
  })$`@graph`

  if (!is.null(graph)) {
    article <- graph[graph[["@type"]] == "NewsArticle", ][1, ]

    # datetime
    datetime <- article$datePublished %>%
      lubridate::as_datetime()

    # headline
    headline <- article$headline

    # author
    author_id <- article$author$`@id`[1]
    author <- graph[["name"]][graph[["@id"]] == author_id] %>%
      toString()

    # text
    text <- html %>%
      html_search(c(".custom-prose p", "p"), attributes = "text", all = FALSE, n = Inf) %>%
      paste(collapse = "\n")

    image_id <- article$image$`@id`[1]
    cover_image_url <- utils::head(graph[["url"]][graph[["@id"]] == image_id], 1L)

    type <- article$`@type`

    s_n_list(
      datetime,
      author,
      headline,
      text,
      type,
      cover_image_url
    )
  } else {
    s_n_list()
  }

}
