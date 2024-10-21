#' @export
pb_deliver_paper.vox_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    if (isTRUE(is.na(json_txt)) || length(json_txt) == 0) {
        return(s_n_list())
    } else {
        json_df <- jsonlite::fromJSON(json_txt[1])
        if (length(json_df$`@type`) > 1) {
            json_df <- json_df[json_df$`@type` == "Article", ]
        }
        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- json_df$articleBody
        if (author == "VOX Online") {
            # the text might have the author abbr. at the end
            author_abbr <- sub(".*\\(([^)]+)\\)$", "\\1", text)
            if (author_abbr != "") {
                author <- author_abbr
            }
        }
        s_n_list(
            datetime,
            author,
            headline,
            text,
            json_df # dumping the whole json data of an article
        )
    }
}
