# Supply paperboy with existing crawl data

This function lets you use
[pb_deliver](https://jbgruber.github.io/paperboy/reference/pb_deliver.md)
to parse already-collected raw HTML by constructing a suitable
data.frame. It is broadly equivalent to
[pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md),
but collects no data.

## Usage

``` r
pb_supply(
  data,
  url = "url",
  content_raw = NULL,
  content_filenames = NULL,
  expanded_url = NULL,
  domain = NULL,
  status = NULL,
  collected_at = lubridate::now()
)
```

## Arguments

- data:

  A data.frame with input data. At a minimum this must contain a column
  of original urls and one of raw HTML data fetched from these URLs.

- url:

  The column name containing the original URLs.

- content_raw:

  A column name containing the raw HTML fetched from these URLs. Exactly
  one of `content_raw` and `content_filenames` must be provided.

- content_filenames:

  A column name containing filenames for the raw HTML data fetched from
  these URLs. Exactly one of `content_raw` and `content_filenames` must
  be provided.

- expanded_url:

  The column name containing final (normalized and/or redirected) URLs.
  If `NULL`,
  [curl_parse_url](https://rdrr.io/pkg/curl/man/curl_parse_url.html) is
  used to normalize the URLs in `data[[urls]]`.

- domain:

  The column name containing the domain to be used to select a parser by
  [pb_deliver](https://jbgruber.github.io/paperboy/reference/pb_deliver.md).
  If `NULL`, the correct domains are calculated.

- status:

  The column name containing HTTP response codes. If `NULL`, 200 ("OK")
  is assumed for for all pages.

- collected_at:

  The `POSIXct` time when the data were collected. Note that paperboy
  records a single time per data.frame, not per URL.

## Value

A data.frame (tibble) equivalent to that returned from
[pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

## Details

If `content_raw` is provided, content will be kept in memory, as with
`pb_collect(save_dir = NULL)`. If `content_filenames` is provided then
the output data.frame will contain links to the data files, as with
`pb_collect(save_dir = 'some_directory')`.

## Examples

``` r
df <- dplyr::tibble(
  url = c('bbc.co.uk/news/articles/cz7dlgejqylo',
          'bbc.co.uk/news/articles/c1l1r1zne1ro'),
  html_data = c('<!DOCTYPE html><html lang="en-GB" class="no-js"><he...',
                '<!DOCTYPE html><html lang="en-GB"><head><meta name=...'),
  expanded_url = c('https://www.bbc.co.uk/news/articles/cz7dlgejqylo',
                   'https://www.bbc.co.uk/news/articles/c1l1r1zne1ro')
)
pb_supply(df,
          content_raw = 'html_data',
          expanded_url = 'expanded_url',
          collected_at = lubridate::ymd_hms('2026-08-20 11:14:05')
)
#> # A tibble: 2 × 5
#>   url                                  expanded_url    domain status content_raw
#>   <chr>                                <chr>           <chr>   <int> <html_cnt> 
#> 1 bbc.co.uk/news/articles/cz7dlgejqylo https://www.bb… bbc.c…    200 <!DOCTYPE …
#> 2 bbc.co.uk/news/articles/c1l1r1zne1ro https://www.bb… bbc.c…    200 <!DOCTYPE …
```
