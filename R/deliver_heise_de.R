#' @export
pb_deliver_paper.heise_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)
    datetime <- lubridate::as_datetime(json_df$datePublished)
    headline <- json_df$headline
    author <- toString(json_df$author$name)

    text <- html %>%
        rvest::html_nodes("#lead,#article-content-body .ringCommonDetail.ringBlockType-paragraph,.article-content,.a-article-header__lead") %>%
        rvest::html_text2() %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
