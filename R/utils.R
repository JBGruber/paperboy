#
normalise_df <- function(df) {
  df <- tibble::as_tibble(df)
  expected_cols <- c(
    "url",
    "expanded_url",
    "domain",
    "status",
    "datetime",
    "headline",
    "author",
    "text"
  )
  missing_cols <- setdiff(expected_cols, colnames(df))
  for (c in missing_cols) {
    df <- tibble::add_column(df, !!c := NA)
  }
  not_expected_cols <- setdiff(colnames(df), expected_cols)
  df <- tidyr::nest(df, misc = tidyselect::all_of(not_expected_cols))
  expected_cols <- c(expected_cols, "misc")
  dplyr::relocate(df, !!expected_cols)
}
