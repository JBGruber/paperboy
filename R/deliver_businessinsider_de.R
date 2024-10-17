#' @export
pb_deliver_paper.businessinsider_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)
    json_df <- json_df$`@graph`
    if (any(json_df$`@type` == "Person")) {
        author <- toString(json_df$name[json_df$`@type` == "Person"])
    } else {
        author <- ""
    }
    json_df <- json_df[1, ]
    datetime <- lubridate::as_datetime(json_df$datePublished)
    headline <- json_df$headline
    text <- html %>%
        rvest::html_node(".article-main") |>
        rvest::html_nodes("p, h2") %>%
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
