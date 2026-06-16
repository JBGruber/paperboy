#' @export
pb_deliver_paper.abendblatt_de <- function(x, verbose = NULL, pb, ...) {
    pb_tick(x, verbose, pb)
    # raw html is stored in column content_raw
    html <- rvest::read_html(x$content_raw)

    json_txt <- rvest::html_elements(
        html,
        "script[type = \"application/ld+json\"]"
    ) %>%
        rvest::html_text()
    json_df <- NULL
    for (j in json_txt) {
        parsed <- tryCatch(jsonlite::fromJSON(j), error = function(e) NULL)
        if (!is.null(parsed) && any(grepl("Article", parsed[["@type"]]))) {
            json_df <- parsed
            break
        }
    }
    if (is.null(json_df)) {
        return(s_n_list())
    }

    # datetime
    datetime <- lubridate::as_datetime(json_df$datePublished)

    # author
    author <- toString(json_df$author$name)

    # headline
    headline <- json_df$headline

    # text
    text <- json_df$articleBody
    if (is.null(text) || !nzchar(text)) {
        text <- html %>%
            rvest::html_elements(".article-body h3, .article-body p") %>%
            rvest::html_text2() %>%
            paste(collapse = "\n")
    }

    # paywalled articles do not include the body text in the html
    paywall <- !is.null(json_df$isAccessibleForFree) &&
        tolower(as.character(json_df$isAccessibleForFree)[1]) %in%
            c("false", "0")
    if (paywall) {
        text <- trimws(paste("[Paywall-Truncated]", text))
    }

    s_n_list(
        datetime,
        author,
        headline,
        text,
        paywall
    )
}
# rss feed includes pages that cannot be parsed because they are subpages
# rss feed also includes podcast, which cannot be parsed
