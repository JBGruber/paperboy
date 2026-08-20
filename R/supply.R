#' Supply paperboy with existing crawl data
#'
#' This function lets you use \link{pb_deliver} to parse already-collected raw
#' HTML by constructing a suitable data.frame. It is broadly equivalent to
#' \link{pb_collect}, but collects no data.
#'
#' @param urls Character vector with original URLs.
#' @param contents_raw Character vector with raw HTML fetched from these URLs.
#' @param expanded_urls Character vector with final (normalized and/or
#'   redirected) URLs. If \code{NULL}, \link[curl]{curl_parse_url} is used to
#'   normalize the URLs in \code{urls}.
#' @param statuses Integer vector with the HTTP response codes. The default
#'   assumption is 200 ("OK") for for all pages.
#' @param collected_at The \code{POSIXct} time when the data were collected.
#'   Note that paperboy records a single time per data.frame, not per URL.
#'
#' @return A data.frame (tibble) equivalent to that returned from
#'   \link{pb_collect}.
#'
#' @seealso \link{pb_collect}
#'
#' @examples
#' pb_supply(
#'   urls = c('bbc.co.uk/news/articles/cz7dlgejqylo',
#'            'bbc.co.uk/news/articles/c1l1r1zne1ro'),
#'   contents_raw = c('<!DOCTYPE html><html lang="en-GB" class="no-js"><he...',
#'                    '<!DOCTYPE html><html lang="en-GB"><head><meta name=...'),
#'   expanded_urls = c('https://www.bbc.co.uk/news/articles/cz7dlgejqylo',
#'                     'https://www.bbc.co.uk/news/articles/c1l1r1zne1ro'),
#'   collected_at = lubridate::ymd_hms('2026-08-20 11:14:05')
#' )
#'
#' @export
pb_supply <- function(urls,
                      contents_raw,
                      expanded_urls = NULL,
                      statuses = rep(200L, length(urls)),
                      collected_at = lubridate::now()) {

  n <- length(urls)
  if (is.null(expanded_urls)) {
    # When curl is used to fetch web pages it does some normalization. We want
    # the expanded_urls to be valid and as normalized as possible, though we
    # cannot follow through redirects etc. as we would be able to when actually
    # fetching. If the user would prefer to use actually-final URLs then they
    # can supply their own in expanded_urls.
    norm_url <- function(u) curl::curl_parse_url(u, default_scheme = TRUE)$url
    expanded_urls <- sapply(urls, norm_url)
  }

  # We do some class-checking here to attempt to guarantee that the outbound
  # interface from this function is comparable to that of pb_collect. There's no
  # reason at the time of writing to assert that collected_at is POSIXct, for
  # example, but if downstream users expect that of paperboy tibbles as a result
  # of pb_collect's current behaviour we would be rude to give them something
  # else (and bugs/crashes as a result of time format differences are all too
  # common).
  if (length(collected_at) != 1 |
      !("POSIXct" %in% class(collected_at))) {
    cli::cli_abort("Only a single POSIXct time is valid for collected_at.",
                   .envir = paperboy.env)
  }
  # If we have integers (or something that coerces cleanly to them) then fine.
  if (all(statuses == as.integer(statuses))) {
    statuses <- as.integer(statuses)
  } else {
    cli::cli_abort("Only integer values are valid for statuses.",
                   .envir = paperboy.env)
  }
  if (n != length(expanded_urls) |
      n != length(statuses)) {
    cli::cli_abort("All supplied data vectors need to be the same length.",
                   .envir = paperboy.env)
  }
  if (n != length(unique(urls))) {
    paperboy.env$len_urls <- n
    paperboy.env$len_unique_urls <- length(unique(urls))
    cli::cli_warn("Only {len_urls} of {len_unique_urls} supplied are unique. Processing duplicates anyway.",
                  .envir = paperboy.env
    )
  }

  df <- tibble::tibble(url = urls,
                       expanded_url = expanded_urls,
                       domain = adaR::ada_get_domain(expanded_urls),
                       status = statuses,
                       content_raw = contents_raw
  )

  class(df$content_raw) <- "html_content"
  attr(df, "paperboy_collected_at") <- collected_at
  attr(df, "paperboy_data_loc") <- "memory"

  df
}
