#' internal function to deliver specific newspapers
#' @param x A data.frame returned by  \link{pb_collect} with an additional class
#'   indicating the domain of all links.
#' @inheritParams pb_deliver
#' @keywords internal
pb_deliver_paper.default <- function(x, verbose = NULL, ...) {

  # If verbose is not explicitly defined, use package default stored in options.
  if (is.null(verbose)) verbose <- getOption("paperboy_verbose")

  class_test(x)

  if (verbose) {
    message("\t...", nrow(x), " articles from ", x$domain[1])
  }
  warning("\t...No method for domain ", x$domain[1], " yet, attempting generic approach")

  # helper function to make progress bar
  pb <- make_pb(x)

  # iterate over all URLs and normalise data.frame
  purrr::map_df(x$content_raw, parse_default, verbose, pb) %>%
    cbind(x) %>%
    normalise_df() %>%
    return()

}

# define parsing function iterate over the URLs
parse_default <- function(html, verbose, pb) {

  . <- NULL

  # raw html is stored in column content_raw
  html <- rvest::read_html(html)
  if (verbose) pb$tick()

  # datetime
  datetime <- html %>%
    html_search(selectors = c(
      "time",
      "[name=\"pubdate\"]",
      "[name=\"parsely-pub-date\"]",
      "[name=\"article:published_time\"]",
      "[name=\"datePublished\"]",
      "[name=\"ga-publishDate\"]",
      "[name=\"dcterms.created\"]",
      "[name=\"sailthru.date\"]",
      "[name=\"parsely-pub-date\"]",
      "lit-timestamp"
    ), attributes = c("content", "datetime", "publishdate")) %>%
    lubridate::as_datetime()

  # headline
  headline <- html %>%
    html_search(selectors = c(
      "[property=\"sailthru.title\"]",
      "[property=\"og:title\"]",
      ".headline__title",
      ".headline__subtitle",
      ".js-headline",
      ".headline",
      ".pg-headline",
      ".headline>h1",
      ".headline__text",
      "[property =\"mol:headline\"]",
      "[id*=\"video-headline\"]",
      "title"
    ), attributes = c("content", "text"))

  # author
  author <- html %>%
    html_search(selectors = c(
      ".atc-MetaAuthorLink,.entry-author",
      ".author",
      ".author-card__name",
      ".wire-byline",
      ".authors",
      ".byline",
      "[class*=\"author-name \"]",
      "[class*=\"byline__author\"]",
      "[class*=\"c-globalAuthor_link\"]",
      "[class*=\"content__meta--byline\"]",
      "[class=\"author\"]",
      "[data-qa=\"author-name\"]",
      "[name=\"author\"]",
      "[name=\"byl\"]",
      "[name=\"parsely-author\"]",
      "[name=\"sailthru.author\"]",
      "[property=\"article:author\"]",
      "[property=\"author\"]"
    ), attributes = c("content", "text"),
    n = Inf) %>%
    toString() %>%
    ifelse(nchar(.) > 0, ., NA_character_)

  # text
  text <-  html %>%
    html_search(selectors = c(
      ".article-body",
      ".article-content",
      ".article-main-body>p",
      ".c-CmsContent>p",
      ".content__body",
      ".entry-video__content__description",
      ".page-article-container>p",
      ".zn-body-text",
      "[class*=\"article-body-text\"]",
      "[class*=\"content\"]>p",
      "[class=\"article-body\"]",
      "[class=\"atc-IntroText\"]",
      "[class=\"atc-TextParagraph\"]",
      "[itemprop=\"articleBody\"]>p",
      "[name=\"articleBody\"]",
      "p:not(.bio__description)",
      "p:not([id|=\"footer\"])",
      "p"
    ), attributes = c("content", "text"),
    n = Inf) %>%
    paste(collapse = "\n")

  # the helper function safely makes creates a named list from objects
  s_n_list(
    datetime,
    author,
    headline,
    text
  )

}
