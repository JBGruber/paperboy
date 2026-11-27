#' @export
pb_deliver_paper.freiepresse_de <- function(x, verbose = NULL, pb, ...) {
  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  nodes <- html %>%
    rvest::html_elements("script[type=\"application/ld+json\"]") %>%
    rvest::html_text() %>%
    lapply(function(s) {
      parsed <- tryCatch(
        jsonlite::fromJSON(s, simplifyVector = FALSE),
        error = function(e) NULL
      )
      if (!is.null(parsed[["@graph"]])) parsed[["@graph"]] else list(parsed)
    }) %>%
    unlist(recursive = FALSE)

  is_article <- vapply(nodes, function(n) {
    "NewsArticle" %in% unlist(n[["@type"]]) && !is.null(n[["headline"]])
  }, logical(1))
  article <- if (any(is_article)) nodes[[which(is_article)[1]]] else list()

  # datetime
  datetime <- (article[["datePublished"]] %||%
    html_search(
      html,
      c("[property=\"article:published_time\"]", "time[datetime]"),
      c("content", "datetime"),
      all = FALSE
    )) %>%
    lubridate::as_datetime()

  # headline
  headline <- article[["headline"]] %||%
    html_search(
      html,
      c("[property=\"og:title\"]", "span.article__headline", "h1"),
      c("content", "text"),
      all = FALSE
    )

  # author
  author_nodes <- article[["author"]]
  if (!is.null(names(author_nodes))) author_nodes <- list(author_nodes)
  author <- unlist(lapply(author_nodes, function(a) {
    if (!is.null(a[["name"]])) return(a[["name"]])
    referenced <- nodes[vapply(
      nodes,
      function(n) identical(n[["@id"]], a[["@id"]]) && !is.null(n[["name"]]),
      logical(1)
    )]
    if (length(referenced) > 0) referenced[[1]][["name"]] else NULL
  }))
  if (length(author) == 0) {
    author <- sub(
      "^Von\\s+", "",
      html_search(html, c("div.author__name", "div.article__author"), "text", all = FALSE)
    )
  }
  author <- toString(author)

  # text
  blocks <- html %>%
    rvest::html_elements("div.article__text > *")
  blocks <- blocks[!grepl("paywall|rgt|newsletter", rvest::html_attr(blocks, "class"))]
  text <- blocks %>%
    rvest::html_text2() %>%
    subset(nzchar(.)) %>%
    paste(collapse = "\n")

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
