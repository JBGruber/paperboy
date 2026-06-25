#' @export
pb_deliver_paper.cnn_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # datetime
  datetime <- html %>%
    rvest::html_elements("[name=\"pubdate\"],[name=\"parsely-pub-date\"],[property=\"article:published_time\"]") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime() %>%
    utils::head(1L)

  # headline
  headline <- tryCatch({
    json <- html %>%
      rvest::html_element('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()
    h <- json$headline
    h <- h[nzchar(h)][1]
    if (is.null(h) || is.na(h) || !nzchar(h)) stop("no headline")
    h
  }, error = function(e) {
    html %>%
      html_search(c("h1.headline__text", ".pg-headline", ".headline__text"),
                  "text") %>%
      utils::head(1L)
  })

  # author
  author <- html %>%
    html_search(c(".Authors__writer", "[name=\"author\"]", ".byline__names"),
                c("text", "content")) %>%
    toString() %>%
    gsub("^By\\s", "", .)

  # text
  text <- tryCatch({
    json <- html %>%
      rvest::html_element('script[type="application/ld+json"]') %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()
    body <- json$articleBody
    body <- body[nzchar(body)][1]
    if (is.null(body) || is.na(body) || !nzchar(body)) stop("no articleBody")
    body
  }, error = function(e) {
    html %>%
      rvest::html_elements(".article__content p:not(.editor-note),.zn-body-text,article,.article__main") %>%
      rvest::html_text2() %>%
      paste(collapse = "\n")
  })

  # type
  content_type <- html %>%
    rvest::html_element("[property=\"og:title\"]") %>%
    rvest::html_attr("content") %>%
    toString() %>%
    {
      x <- .
      dplyr::case_when(
        grepl("Live", x, ignore.case = TRUE) ~ "live",
        grepl("Video", x, ignore.case = TRUE) ~ "video",
        TRUE ~ "article"
      )
    }

  s_n_list(
    datetime,
    author,
    headline,
    text,
    content_type
  )

}

pb_deliver_paper.us_cnn_com <-
  pb_deliver_paper.edition_cnn_com <-
  pb_deliver_paper.cnn_com
