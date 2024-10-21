#' @export
pb_deliver_paper.wdr_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    # careful: json can have many objects but the first seems to be the article
    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[1])
        date_tmp <- json_df$datePublished # missing sec
        date_tmp <- sub("(\\d{2}:\\d{2})(\\+\\d{2}:\\d{2})", "\\1:00\\2", date_tmp)
        datetime <- lubridate::as_datetime(date_tmp)
        headline <- json_df$headline
        author <- toString(json_df$author$name) %>% gsub("/", ",", .)
        text <- html %>%
            rvest::html_nodes(".einleitung,.text,.subtitle") %>%
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
# rss feed contains also overviews of articles which make the parser fail
