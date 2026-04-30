# Collect RSS feed

Collect articles from RSS or Atom feed(s)

## Usage

``` r
pb_collect_rss(x, parse = TRUE, ...)
```

## Arguments

- x:

  URL(s) to RSS or Atom feed(s).

- parse:

  Whether the results should be parsed into a data.frame. Turn off for
  debugging.

- ...:

  passed to pb_collect.

## Value

a data.frame or list

## Examples

``` r
if (FALSE) { # \dontrun{
pb_collect_rss("https://www.washingtonpost.com/arcio/rss/")
# works with atom feeds too
pb_collect_rss("https://www.nu.nl/rss")
} # }
```
