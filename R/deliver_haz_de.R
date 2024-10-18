#' @export
pb_deliver_paper.haz_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ") %>% rvest::html_text()
    json_txt <- json_txt[grepl("NewsArticle", json_txt)]
    json_df <- jsonlite::fromJSON(json_txt)

    datetime <- lubridate::as_datetime(json_df$datePublished)
    headline <- json_df$headline
    author <- toString(json_df$author$name)
    text <- html %>%
        rvest::html_nodes(".Articlestyled__ArticleBodyWrapper-sc-7y75gq-2,.Textstyled__Text-sc-1cqv9mi-0.gqSIEH") %>%
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
