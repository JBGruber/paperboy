#' Supply paperboy with existing crawl data
#'
#' This function lets you use \link{pb_deliver} to parse already-collected raw
#' HTML by constructing a suitable data.frame. It is broadly equivalent to
#' \link{pb_collect}, but collects no data.
#'
#' @param data A data.frame with input data. At a minimum this must contain
#'   a column of original urls and one of raw HTML data fetched from these URLs.
#' @param url The column name containing the original URLs.
#' @param content_raw The column name containing the raw HTML fetched from
#'   these URLs.
#' @param expanded_url The column name containing final (normalized and/or
#'   redirected) URLs. If \code{NULL}, \link[curl]{curl_parse_url} is used to
#'   normalize the URLs in \code{data[[urls]]}.
#' @param domain The column name containing the domain to be used to select a
#'   parser by \link{pb_deliver}. If \code{NULL}, the correct domains are
#'   calculated.
#' @param status The column name containing HTTP response codes. If \code{NULL},
#'   assume 200 ("OK") for for all pages.
#' @param collected_at The \code{POSIXct} time when the data were collected.
#'   Note that paperboy records a single time per data.frame, not per URL.
#'
#' @return A data.frame (tibble) equivalent to that returned from
#'   \link{pb_collect}.
#'
#' @seealso \link{pb_collect}
#'
#' @examples
#' df <- dplyr::tibble(
#'   url = c('bbc.co.uk/news/articles/cz7dlgejqylo',
#'           'bbc.co.uk/news/articles/c1l1r1zne1ro'),
#'   html_data = c('<!DOCTYPE html><html lang="en-GB" class="no-js"><he...',
#'                 '<!DOCTYPE html><html lang="en-GB"><head><meta name=...'),
#'   expanded_url = c('https://www.bbc.co.uk/news/articles/cz7dlgejqylo',
#'                    'https://www.bbc.co.uk/news/articles/c1l1r1zne1ro')
#' )
#' pb_supply(df,
#'           content_raw = 'html_data',
#'           expanded_url = 'expanded_url',
#'           collected_at = lubridate::ymd_hms('2026-08-20 11:14:05')
#' )
#'
#' @export
pb_supply <- function(data,
                      url = "url",
                      content_raw = "content_raw",
                      expanded_url = NULL,
                      domain = NULL,
                      status = NULL,
                      collected_at = lubridate::now()) {

  if (is.null(expanded_url)) {
    expanded_url <- "expanded_url"
    # When curl is used to fetch web pages it does some normalization. We want
    # expanded_url to be valid and as normalized as possible, though we
    # cannot follow through redirects etc. as we would be able to when actually
    # fetching. If the user would prefer to use actually-final URLs then they
    # can supply their own column.
    norm_url <- function(u) curl::curl_parse_url(u, default_scheme=TRUE)[[url]]
    data[[expanded_url]] <- sapply(data[[url]], norm_url)
  }
  if (is.null(domain)) {
    domain <- "domain"
    data[[domain]] <- adaR::ada_get_domain(data[[expanded_url]])
  }
  if (is.null(status)) {
    status <- "status"
    data[[status]] <- 200L
  }

  if (any(sapply(c(url, content_raw, expanded_url, domain, status, collected_at),
                 length) != 1)) {
    cli::cli_abort("All parameters supplied to pb_supply() must be length 1.",
                  .envir = paperboy.env
    )
  }

  if (nrow(data) != length(unique(data[[url]]))) {
    paperboy.env$len_urls <- nrow(data)
    paperboy.env$len_unique_urls <- length(unique(data[[url]]))
    cli::cli_warn("Only {len_urls} of {len_unique_urls} supplied are unique. Processing duplicates anyway.",
                  .envir = paperboy.env
    )
  }

  # We do some class-checking here to attempt to guarantee that the outbound
  # interface from this function is comparable to that of pb_collect. There's no
  # reason at the time of writing to assert that collected_at is POSIXct, for
  # example, but if downstream users expect that of paperboy tibbles as a result
  # of pb_collect's current behaviour we would be rude to give them something
  # else (and bugs/crashes as a result of time format differences are all too
  # common).
  if (!(inherits(collected_at, "POSIXct"))) {
    cli::cli_abort("Only a POSIXct time is valid for collected_at.",
                   .envir = paperboy.env)
  }
  # If we have integers (or something that coerces cleanly to them) then fine.
  if (all(data[[status]] != as.integer(data[[status]]))) {
    cli::cli_warn("Only integer values are valid for statuses. Coercing anyway.",
                   .envir = paperboy.env)
  }
  data[[status]] <- as.integer(data[[status]])

  data <- data %>%
    dplyr::as_tibble() %>%
    dplyr::rename(url = url,
                  expanded_url = expanded_url,
                  domain = domain,
                  status = status,
                  content_raw = content_raw) %>%
    dplyr::select(url, expanded_url, domain, status, content_raw)

  class(data$content_raw) <- "html_content"
  attr(data, "paperboy_collected_at") <- collected_at
  attr(data, "paperboy_data_loc") <- "memory"

  data
}
