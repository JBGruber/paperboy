#' @export
pb_deliver_paper.handelsblatt_com <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    # html <- rvest::read_html(x$content_raw)
    base_url <- "https://content.www.handelsblatt.com/api/content/eager/?url="
    path <- adaR::ada_get_pathname(x$expanded_url)
    json_df <- tryCatch(jsonlite::fromJSON(paste0(base_url, path)), error = function(e) list(type = "404"))
    if (json_df$type == "redirect") {
        path <- json_df$location
        json_df <- jsonlite::fromJSON(paste0(base_url, path))
    } else if (json_df$type == "404") {
        html <- rvest::read_html(x$content_raw)
        weekdays_de <- paste0(c("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"), collapse = "|")
        months_de <- c("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")

        date_string <- html %>%
            rvest::html_node(".post-date .meta-text") |>
            rvest::html_text2()
        date_string <- gsub(weekdays_de, "", date_string)


        for (i in seq_along(months_de)) {
            date_string <- gsub(months_de[i], i, date_string)
        }

        date_string <- gsub("Uhr", "", date_string)
        date_string <- gsub("‒", "", date_string)
        date_string <- gsub(",", "", date_string)

        datetime <- lubridate::as_datetime(date_string, format = "%d. %m %Y %H:%M ")
        headline <- html %>%
            rvest::html_node("h1.entry-title") %>%
            rvest::html_text()
        author <- ""
        text <- html %>%
            rvest::html_nodes(".entry-content p, .entry-content h2") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")
    } else {
        datetime <- lubridate::as_datetime(json_df$header$dates$published)
        headline <- json_df$header$headline
        author <- toString(paste(json_df$authors$firstName, json_df$authors$lastName))
        text <- jsonlite::fromJSON(json_df$seo$jsonLd)$articleBody
        text <- text[!is.na(text)]
        text <- paste(text, collapse = "\n")
    }
    s_n_list(
        datetime,
        author,
        headline,
        text
    )
}
