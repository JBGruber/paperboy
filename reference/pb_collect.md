# Collect data from supplied URLs

Collect data from supplied URLs

## Usage

``` r
pb_collect(
  urls,
  collect_rss = TRUE,
  timeout = 30,
  ignore_fails = FALSE,
  connections = 100L,
  host_con = 6L,
  use_cookies = FALSE,
  useragent = "paperboy",
  save_dir = NULL,
  verbose = NULL,
  ...
)
```

## Arguments

- urls:

  Character object with URLs.

- collect_rss:

  If one of the URLs contains an RSS feed, should it be parsed.

- timeout:

  How long should the function wait for the connection (in seconds). If
  the query finishes earlier, results are returned immediately.

- ignore_fails:

  normally the function errors when a URL can't be reached due to
  connection issues. Setting to TRUE ignores this.

- connections:

  max total concurrent connections.

- host_con:

  max concurrent connections per host.

- use_cookies:

  If `TRUE`, use the `cookiemonster` package to handle cookies. See
  [add_cookies](https://rdrr.io/pkg/cookiemonster/man/add_cookies.html)
  for details on how to store cookies. Cookies are used to enter
  articles behind a paywall or consent form.

- useragent:

  String to be sent in the User-Agent header.

- save_dir:

  store raw html data on disk instead of memory by providing a path to a
  directory.

- verbose:

  A logical flag indicating whether information should be printed to the
  screen. If `NULL` will be determined from
  `getOption("paperboy_verbose")`.

- ...:

  Currently not used

## Value

A data.frame (tibble) with url status data and raw media text.
