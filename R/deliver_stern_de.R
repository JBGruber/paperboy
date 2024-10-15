#' @export
pb_deliver_paper.stern_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_nodes(html, "script[type = \"application/ld+json\"] ")[1] |> rvest::html_text()
    json_df <- jsonlite::fromJSON(json_txt)[1, ]

    datetime <- lubridate::as_datetime(json_df$datePublished)
    headline <- json_df$headline
    author <- toString(json_df$author$name)
    text <- html %>%
        rvest::html_elements(".intro,.text-element") %>%
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
