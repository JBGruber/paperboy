#' @export
pb_deliver_paper.waz_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        if (length(json_txt) == 1) {
            return(s_n_list())
        }
        json_df <- jsonlite::fromJSON(json_txt[2])

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_elements(".article-body p,.article-body h3") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")

        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
