#' @export
pb_deliver_paper.freiepresse_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt))) {
        return(s_n_list())
    } else {
        json_txt <- json_txt[grepl("NewsArticle", json_txt)]
        if (length(json_txt) == 0) {
            return(s_n_list())
        }
        json_df <- jsonlite::fromJSON(json_txt)

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author)
        text <- html %>%
            rvest::html_nodes(".article__text p,.article__text h2") %>%
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
