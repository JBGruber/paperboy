#' @export
pb_deliver_paper.bild_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    # get page context
    page_context <- html %>%
      rvest::html_element("script#pageContext") %>%
      rvest::html_text() %>%
      jsonlite::fromJSON()

    meta <- page_context$CLIENT_STORE_INITIAL_STATE$pageAggregation$meta

    # date
    datetime <- meta$publicationDate

    # headline
    headline <-meta$title

    # author
    author <- meta$author

    # text
    text <- html %>%
        rvest::html_elements(".article-body") %>%
        rvest::html_text() %>%
        paste(collapse = "\n")

    # content type, e.g. article, video
    content_type <- meta$documentType

    # the helper function safely creates a named list from objects
    s_n_list(
        datetime,
        author,
        headline,
        text,
        content_type
    )
}
