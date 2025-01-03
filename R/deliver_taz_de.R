#' @export
pb_deliver_paper.taz_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text2()
    if (isTRUE(is.na(json_txt)) || length(json_txt) <= 2) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[3])

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- json_df$articleBody

        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
