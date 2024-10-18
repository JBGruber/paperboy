#' @export
pb_deliver_paper.vox_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)
    if (nrow(json_df) > 1) {
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
