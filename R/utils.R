#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' Show available scrapers
#'
#' @return A character vector of supported domains.
#' @export
#'
#' @examples
#' pb_available()
pb_available <- function() {
  . <- NULL
  utils::lsf.str(envir = asNamespace("paperboy"), all = TRUE) %>%
    unclass() %>%
    grep("pb_deliver_paper.", ., value = TRUE) %>%
    gsub("pb_deliver_paper.", "", ., fixed = TRUE) %>%
    .[. != "default"] %>%
    gsub("_", ".", ., fixed = TRUE)
}

#' @keywords internal
make_pb <- function(df) {
  progress::progress_bar$new(
    format = "[:bar] :percent eta: :eta",
    total = nrow(df)
  )
}

#' @keywords internal
len_check <- function(x) {
  if (length(x) == 0L) {
    return(NA)
  } else {
    return(x)
  }
}

#' @keywords internal
normalise_df <- function(df) {
  df <- tibble::as_tibble(df)
  expected_cols <- c(
    "url",
    "expanded_url",
    "domain",
    "status",
    "datetime",
    "author",
    "headline",
    "text"
  )
  missing_cols <- setdiff(expected_cols, colnames(df))
  for (c in missing_cols) {
    df <- tibble::add_column(df, !!c := NA)
  }
  not_expected_cols <- setdiff(colnames(df), c(expected_cols, "content_raw"))
  df <- tidyr::nest(df, misc = tidyselect::all_of(not_expected_cols))
  expected_cols <- c(expected_cols, "misc")
  dplyr::select(df, !!expected_cols)
}
