#' @export
pb_deliver_paper.ndr_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)
    if (json_df$`@type` != "VideoObject" && json_df$`@type` != "AudioObject") { # NewsArticle
        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_nodes(".modulepadding.copytext p, .modulepadding.copytext h2") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")
    } else {
        datetime <- lubridate::as_datetime(json_df$uploadDate)
        headline <- json_df$name
        author <- ""
        text <- json_df$description
    }
    s_n_list(
        datetime,
        author,
        headline,
        text,
        json_df # dumping the whole json data of an article
    )
}
