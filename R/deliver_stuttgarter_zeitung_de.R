#' @export
pb_deliver_paper.stuttgarter_zeitung_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)

    datetime <- lubridate::as_datetime(json_df$datePublished)
    headline <- json_df$headline
    author <- toString(json_df$author$name)
    text <- html %>%
        rvest::html_nodes(".brick.intro-text p,.brickgroup p,.brickgroup h2") %>%
        rvest::html_text2()
    rm_text <- c("StZ-Plus-Abonnement", "Vertrag mit Werbung")

    text <- text[!text %in% rm_text] %>%
        paste(collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text,
        json_df # dumping the whole json data of an article
    )
}
# rss feed includes pages that cannot be parsed because they are subpages
# rss feed also includes podcast, which cannot be parsed
