#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`


#' Show available parsers
#'
#' @param ... optionally pass URLs to check if respective parser(s) is/are available.
#'
#' @return A character vector of supported domains.
#' @export
#'
#' @examples
#' pb_available()
#' pb_available("https://edition.cnn.com/",
#'              "https://www.nytimes.com/",
#'              "https://www.google.com/")
pb_available <- function(...) {

  parsers <- utils::lsf.str(envir = asNamespace("paperboy"), all = TRUE) %>%
    unclass() %>%
    grep("pb_deliver_paper.", ., value = TRUE) %>%
    gsub("pb_deliver_paper.", "", ., fixed = TRUE) %>%
    .[!. %in% c("default", "httpbin_org")] %>%
    gsub("_", ".", ., fixed = TRUE)

  dots <- list(...)

  if (length(dots) > 0) {
    names(dots) <- dots
    return(sapply(dots, function(x) adaR::ada_get_domain(x) %in% parsers, USE.NAMES = TRUE))
  }

  return(parsers)
}


#' not as is sounds, turns urls into class conform string
#' @noRd
classify <- function(url) {
  replace_all(url, c(".", "-"), rep("_", 2L), fixed = TRUE)
}


#' safe make named list from objects
#' @noRd
s_n_list <- function(...) {
  nms <- sapply(as.list(substitute(list(...))), deparse)[-1]

  out <- lapply(list(...), len_check)

  tibble::as_tibble(stats::setNames(out, nms))
}


#' force length 1
#' @noRd
len_check <- function(x) {
  if (length(x) == 0L) {
    return(NA)
  } else if (length(x) > 1L) {
    return(list(x))
  } else {
    return(x)
  }
}


#' @noRd
#' @importFrom rlang :=
normalise_df <- function(df) {

  df <- tibble::as_tibble(df)

  # the default columns every parser is expected to extract
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
    df <- tibble::add_column(df, {{c}} := NA)
  }

  not_expected_cols <- setdiff(colnames(df), c(expected_cols, "content_raw"))

  df <- tidyr::nest(df, misc = tidyselect::all_of(not_expected_cols))

  expected_cols <- c(expected_cols, "misc")

  dplyr::select(df, !!expected_cols)

}


#' base R version of stringi::stri_replace_all() to limit dependencies
#' @noRd
replace_all <- function(str, pattern, replacement, fixed = TRUE) {
  for (i in seq_along(pattern)) str <- gsub(pattern[i], replacement[i], str, fixed = fixed)
  return(str)
}


#' base R version of stringi::stri_extract()
#' @keywords internal
extract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str, perl = TRUE))
}


#' construct progress bar
#' @noRd
make_pb <- function(df) {
  cli::cli_progress_bar("Parsing ", total = nrow(df))
}


#' tick progress bar
#' @noRd
pb_tick <- function(x, verbose, pb) {
  if (verbose > 1) {
    cli::cli_progress_step(x$expanded_url)
  } else if (verbose > 0) {
    cli::cli_progress_update(status = paste0("(", x$domain, ")"), id = pb)
  }
}


#' issue warning once per unknown domain
#' @noRd
warn_once <- function(id) {
  if (is.null(inform_env[[id]])) {
    inform_now_env[[id]] <- cli::format_warning("No parser for domain {.strong {id}} yet, attempting generic approach.")
    inform_env[[id]] <- TRUE
  }
}


the <- new.env()
inform_env <- new.env()
inform_now_env <- new.env()
