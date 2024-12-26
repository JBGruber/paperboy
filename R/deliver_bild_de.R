#' @export
pb_deliver_paper.bild_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    datetime <- html %>%
        rvest::html_element("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()

    # headline
    headline <- html %>%
        rvest::html_elements(".document-title__headline") %>%
        rvest::html_text()

    # author
    author <- html %>%
        rvest::html_elements(".article_author") %>%
        rvest::html_text() %>%
        toString()

    # text
    text <- html %>%
        rvest::html_elements(".article-body") %>%
        rvest::html_text() %>%
        paste(collapse = "\n")

    # the helper function safely creates a named list from objects
    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
