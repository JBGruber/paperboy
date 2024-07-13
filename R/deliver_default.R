#' @export
pb_deliver_paper.default <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)
  # raw html is stored in column content_raw
  html <- try(rvest::read_html(x$content_raw), silent = TRUE)
  if (methods::is(html, "try-error")) {
    # TODO: work-around for weird encoding issues
    tmp <- tempfile(fileext = ".html")
    writeLines(gsub("[^ -~]+", "", x$content_raw , useBytes = TRUE), tmp)
    html <- rvest::read_html(tmp)
  }
  warn_once(x$domain)

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
