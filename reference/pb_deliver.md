# Deliver online news articles

This function will determine the website of the urls given to it and
call the appropriate webscraper.

## Usage

``` r
pb_deliver(x, try_default = TRUE, ignore_fails = FALSE, verbose = NULL, ...)
```

## Arguments

- x:

  Either a vector of URLs or a data.frame returned by
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

- try_default:

  if no parser is available, should a generic parser be used `TRUE` or
  should the URL be skipped `FALSE`?

- ignore_fails:

  normally the function errors raw content for a URL can't be parsed.
  Setting to `TRUE` ignores all parsing errors (use with caution).

- verbose:

  `FALSE` turns deliver silent. `TRUE` prints status messages and a
  progress bar on the screen. `2L` turns on debug mode. If `NULL` will
  be determined from `getOption("paperboy_verbose")`.

- ...:

  Passed on to
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

## Value

A data.frame (tibble) with media data and full text.
