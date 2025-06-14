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

  dots <- unlist(list(...), recursive = TRUE)

  if (length(dots) > 0) {
    return(unlist(sapply(dots, function(x) url_get_domain(x) %in% parsers,
                         simplify = FALSE, USE.NAMES = TRUE)))
  }

  return(parsers)
}


#' not as is sounds, turns urls into class conform string
#' @noRd
classify <- function(url) {
  # as.factor improves speed
  url <- sub("^www\\.", "", as.factor(url)) # remove www for compatibility
  gsub("\\.|\\-", "_", as.factor(url))
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
normalise_df <- function(l) {

  # find columns that are a list in any tbl
  list_cols <- purrr::map(l, function(df) {
    names(which(purrr::map_lgl(df, is.list)))
  }) %>%
    unlist() %>%
    unique()

  # make the same column in all tbls a list
  if (!is.null(list_cols)) {
    for (i in seq_along(l)) {
      l[[i]] <- dplyr::mutate(l[[i]], dplyr::across(tidyselect::all_of(list_cols), as.list))
    }
  }

  df <- dplyr::bind_rows(l)

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
#' @noRd
extract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str, perl = TRUE))
}


#' replace names of an object given a lookuptable
#' @noRd
replace_names <- function(x, lookup) {
  replacement <- lookup[names(x)]
  names(x) <- ifelse(is.na(replacement), names(x), replacement)
  return(x)
}


#' construct progress bar
#' @noRd
make_pb <- function(df) {
  cli::cli_progress_bar("Parsing ", total = nrow(df))
}


#' tick progress bar
#' @noRd
pb_tick <- function(x, verbose, pb, ...) {
  if (verbose > 1) {
    cli::cli_progress_step(x$expanded_url, ...)
  } else if (verbose > 0) {
    cli::cli_progress_update(status = paste0("(", x$domain, ")"), id = pb, ...)
  }
}


#' issue warning once per unknown domain
#' @noRd
warn_once <- function(id) {
  if (is.null(inform_env[[id]])) {
    inform_now_env[[id]] <- cli::format_message("No parser for domain {.strong {id}} yet, attempting generic approach.")
    inform_env[[id]] <- TRUE
  }
}


#' @exportS3Method rvest::read_html
read_html.html_content <- function(x, ...) {
  rvest::read_html(as.character(x), ...)
}

url_get_basename <- function(x) {
  host <- url_get_domain(x)
  paste0("https://", host)
}


# see https://github.com/schochastics/adaR/issues/36
url_get_domain <- function(x) {
  out <- adaR::ada_get_domain(x)
  if (is.na(out)) out <- adaR::ada_get_domain(paste0("https://", x))
  return(out)
}


exit <- function() invokeRestart("abort")

the <- new.env()
inform_env <- new.env()
inform_now_env <- new.env()
