#' @export
pb_deliver_paper.prosieben_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        if (length(json_txt) == 2) {
            json_txt <- json_txt[2]
        }
        json_df <- jsonlite::fromJSON(json_txt)
        if (json_df$`@type` != "VideoObject" && json_df$`@type` != "FAQPage") { # NewsArticle
            datetime <- lubridate::as_datetime(json_df$datePublished)
            headline <- json_df$headline
            author <- toString(json_df$author$name)
            text <- html %>%
                rvest::html_elements(".css-f9qfdi p.css-bq2685,.css-f9qfdi h2") %>%
                rvest::html_text2() %>%
                paste(collapse = "\n")
        } else if (json_df$`@type` != "FAQPage") {
            return(s_n_list())
        } else {
            datetime <- lubridate::as_datetime(json_df$uploadDate)
            headline <- json_df$name
            author <- ""
            text <- json_df$description # for video objects, use description as text
        }

        s_n_list(
            datetime,
            author,
            headline,
            text
        )
    }
}
