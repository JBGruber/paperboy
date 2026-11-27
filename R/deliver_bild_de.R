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
    datetime <- lubridate::ymd_hms(meta$publicationDate)

    # headline
    headline <- meta$title

    # author
    author <- meta$author
    if (is.null(author) || !nzchar(author)) {
        # documentType "video" etc. carry no author in pageContext; fall back to JSON-LD
        ld_author <- html %>%
            rvest::html_element("script[type='application/ld+json']") %>%
            rvest::html_text() %>%
            jsonlite::fromJSON() %>%
            purrr::pluck("author", 1, "name", .default = NA_character_)
        author <- ld_author
    }
    author <- toString(author)

    # text
    text_nodes <- rvest::html_elements(html, ".article-body p")
    if (length(text_nodes) == 0) text_nodes <- rvest::html_elements(html, "p")
    text <- text_nodes %>%
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
