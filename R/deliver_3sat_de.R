#' @export
pb_deliver_paper.3sat_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)
    datetime <- html %>%
        rvest::html_nodes("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()

    headline <- html %>%
        rvest::html_nodes(".main-content-details h2") %>%
        rvest::html_text()

    author <- "" # no author info found

    text <- html %>%
        rvest::html_nodes(".o--post-long p") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
