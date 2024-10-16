#' @export
pb_deliver_paper.br_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    json_df <- lapply(json_txt, jsonlite::fromJSON)
    if (is.null(names(json_df))) {
        types <- sapply(json_df, function(x) x$`@type`)
        if (any(types == "NewsArticle")) {
            json_df <- json_df[types == "NewsArticle"][[1]]
        } else if (any(type == "VideoObject")) {
            json_df <- json_df[types == "VideoObject"][[1]]
        } else if (any(type == "AudioObject")) {
            json_df <- json_df[types == "AudioObject"][[1]]
        }
    }
    if (json_df$`@type` != "VideoObject" && json_df$`@type` != "AudioObject") { # NewsArticle
        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$author$name)
        text <- html %>%
            rvest::html_node(".RichText_richText__wS9Rz.body3") |>
            rvest::html_nodes("p, h2") %>%
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
