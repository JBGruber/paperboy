#' @export
pb_deliver_paper.suedkurier_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[1])
        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- html %>%
            rvest::html_node("header h1") %>%
            rvest::html_text()
        author <- paste0("<p>", json_df$author$name, "</p>", collapse = ",") %>%
            rvest::read_html() %>%
            rvest::html_text() %>%
            toString()
        text <- html %>%
            rvest::html_nodes(".article-summary,.article-jsonld.article-paywall-summary,.article-jsonld p") %>%
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
