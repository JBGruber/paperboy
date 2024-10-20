#' @export
pb_deliver_paper.t_online_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt))) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[1])
        json_df <- json_df$`@graph`[1, ]

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author[[1]]$name)
        text <- html %>%
            rvest::html_nodes("div[data-testid=\"ArticleBody.StreamLayout\"] p") %>%
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
