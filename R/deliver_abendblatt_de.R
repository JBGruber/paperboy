#' @export
pb_deliver_paper.abendblatt_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt))) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[2])

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_nodes(".article-body h3, .article-body p") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")

        s_n_list(
            datetime,
            author,
            headline,
            text,
            json_df # dumping the whole json data of an article
        )
    }
}
# rss feed includes pages that cannot be parsed because they are subpages
# rss feed also includes podcast, which cannot be parsed
