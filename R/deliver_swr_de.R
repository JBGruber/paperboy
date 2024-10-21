#' @export
pb_deliver_paper.swr_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)


    datetime <- html %>%
        rvest::html_element("time") %>%
        rvest::html_attr("datetime") %>%
        lubridate::as_datetime()
    headline <- html %>%
        rvest::html_element("h1.headline") %>%
        rvest::html_text()
    author <- html %>%
        rvest::html_elements(".meta-top .meta-authors .meta-author-name a") %>%
        rvest::html_text2() %>%
        toString()
    text <- html %>%
        rvest::html_elements(".detail-body .lead, .bodytext p, .bodytext h2") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
