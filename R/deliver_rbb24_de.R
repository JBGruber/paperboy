#' @export
pb_deliver_paper.rbb24_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    datetime <- html %>%
        rvest::html_nodes(".technicalline .lineinfo") %>%
        rvest::html_text2() %>%
        gsub(".*(\\d{2}\\.\\d{2}\\.\\d{2}) \\| (\\d{2}:\\d{2}).*", "\\1 \\2", .) %>%
        lubridate::as_datetime(format = "%d.%m.%y %H:%M", tz = "UTC") # This will not be the correct timezone


    headline <- html %>%
        rvest::html_nodes(".titletext") %>%
        rvest::html_text2()

    author <- "" # no article with author info found

    text <- html %>%
        rvest::html_nodes(".shorttext p, .textblock p, h4.texttitle") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
