#' @export
pb_deliver_paper.deutschlandfunk_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    datetime <- html %>%
        rvest::html_node("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()
    headline <- html %>%
        rvest::html_node(".headline-title") %>%
        rvest::html_text()
    author <- "deutschlandfunk.de" # could not find article with author
    text <- html %>%
        rvest::html_nodes(".article-header-description,.article-details-text:not(.u-text-italic),.article-details-title") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
