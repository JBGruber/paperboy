#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' Create new scraper
#'
#' @param np domain of the newspaper this scraper is for.
#'
#' @keywords internal
#' @examples
#' \dontrun{paperboy:::pb_new(np = "https://www.buzzfeed.com/")}
pb_new <- function(np) {
  . <- NULL
  np <- urltools::domain(np) %>%
    sub("www", "", x = ., fixed = TRUE) %>%
    gsub(".", "_",  x = ., fixed = TRUE)

  template <- system.file("templates", "deliver_.R", package = "paperboy") %>%
    readLines() %>%
    gsub("{{newspaper}}", np, x = ., fixed = TRUE)

  p <- ifelse(basename(getwd()) == "paperboy", "./R/", "")
  f <- paste0(p, "deliver_", np, ".R")
  if (!file.exists(f)) writeLines(template, f)
  if (require(rstudioapi)) {
    rstudioapi::documentOpen(f)
  } else {
    utils::file.edit(f)
  }
}


# A small test to check if x is really a tibble.
class_test <- function(x) {
  if (!methods::is(x, "tbl_df"))
    stop("Wrong object passed to internal deliver function: ", paste(class(x), collapse = ", "))
}

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
    .[!. %in% c("default", "httpbin_org")] %>%
    gsub("_", ".", ., fixed = TRUE)
}

#' @keywords internal
make_pb <- function(df) {
  progress::progress_bar$new(
    format = "[:bar] :percent eta: :eta (:what)",
    total = nrow(df)
  )
}

pb_tick <- function(x, verbose, pb) {
  if (verbose > 1) {
    message(x$expanded_url)
  } else if (verbose > 0) {
    pb$tick(tokens = list(what = x$domain[1]))
  }
}

#' force length 1
#' @keywords internal
len_check <- function(x) {
  if (length(x) == 0L) {
    return(NA)
  } else if (length(x) > 1L) {
    return(list(x))
  } else {
    return(x)
  }
}

#' safe make named list from objects
#' @keywords internal
s_n_list <- function(...) {
  nms <- sapply(as.list(substitute(list(...))), deparse)[-1]

  out <- lapply(list(...), len_check)

  stats::setNames(out, nms)
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

#' base R version of stringi::stri_replace_all()
#' @keywords internal
replace_all <- function(str, pattern, replacement, fixed = TRUE) {
  for(i in seq_along(pattern)) str <- gsub(pattern[i], replacement[i], str, fixed = fixed)
  return(str)
}

#' base R version of stringi::stri_extract()
#' @keywords internal
extract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str, perl = TRUE))
}
