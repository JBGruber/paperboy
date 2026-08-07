#' @export
pb_deliver_paper.cnnbrasil_com_br <- function(x, verbose = NULL, pb, ...) {

  # updates progress bar
  pb_tick(x, verbose, pb)

  # raw html is stored in column content_raw
  html <- rvest::read_html(x$content_raw)

  # The best version of the text and metadata is in a JSON-LD block
  json_txt <- rvest::html_elements(html, "script[id ^= \"schema-api\"]") %>%
    rvest::html_text()
  if (length(json_txt) == 0) return(s_n_list())

  json_df <- jsonlite::fromJSON(json_txt[[1]])[["@graph"]] |>
    dplyr::filter(`@type` == "NewsArticle")
  if (is.null(json_df) || nrow(json_df) != 1) return(s_n_list())

  datetime <- lubridate::as_datetime(json_df$datePublished)
  author <- toString(json_df$author$name)
  headline <- json_df$headline
  text <- trimws(gsub("<[^>]+>", "", json_df$articleBody))

  s_n_list(
    datetime,
    author,
    headline,
    text
  )
}
