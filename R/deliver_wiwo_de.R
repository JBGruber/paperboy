#' @export
pb_deliver_paper.wiwo_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] %>% rvest::html_text()
    if (length(json_txt) != 0) { # otherwise the article is paywalled and not scrapeable
        json_df <- jsonlite::fromJSON(json_txt)

        datetime <- lubridate::as_datetime(json_df$datePublished)
        headline <- json_df$headline
        author <- toString(json_df$creator)
        text <- html %>%
            rvest::html_nodes(".c-leadtext,.u-richtext h3,.u-richtext p") %>%
            rvest::html_text2() %>%
            .[!grepl("Lesen Sie auch", .)] %>% # Remove links in between
            paste(collapse = "\n")
    } else {
        datetime <- NA
        headline <- NA
        author <- NA
        text <- NA
        json_df <- list("no access")
    }
    s_n_list(
        datetime,
        author,
        headline,
        text,
        json_df
    )
}
