#' @export
pb_deliver_paper.derstandard_at <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)
    datetime <- html %>%
        rvest::html_nodes(".article-meta") %>%
        rvest::html_text() %>%
        lubridate::as_datetime()

    headline <- html %>%
        rvest::html_nodes("h1.article-title") %>%
        rvest::html_text()

    author <- html %>%
        rvest::html_nodes(".article-origins") %>%
        rvest::html_text() %>%
        toString()

    text <- html %>%
        rvest::html_nodes(".article-body p, .article-body h3") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n") # There is a note that parts of the website are blocked

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
