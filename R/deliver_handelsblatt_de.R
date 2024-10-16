#' @export
pb_deliver_paper.handelsblatt_com <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    # html <- rvest::read_html(x$content_raw)
    base_url <- "https://content.www.handelsblatt.com/api/content/eager/?url="
    path <- adaR::ada_get_pathname(x$expanded_url)
    json_df <- jsonlite::fromJSON(paste0(base_url, path))
    if (json_df$type == "redirect") {
        path <- json_df$location
        json_df <- jsonlite::fromJSON(paste0(base_url, path))
    }
    datetime <- lubridate::as_datetime(json_df$header$dates$published)
    headline <- json_df$header$headline
    author <- toString(paste(json_df$authors$firstName, json_df$authors$lastName))
    text <- jsonlite::fromJSON(json_df$seo$jsonLd)$articleBody
    text <- text[!is.na(text)]
    text <- paste(text, collapse = "\n")

    s_n_list(
        datetime,
        author,
        headline,
        text,
        json_df # dumping the whole json data of an article
    )
}
