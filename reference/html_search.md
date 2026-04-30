# Search raw html for attributes

Search raw html for attributes

## Usage

``` r
html_search(html, selectors, attributes = NULL, all = TRUE, n = 1L)
```

## Arguments

- html:

  raw html

- selectors:

  a vector of CSS selectors to include in search.

- attributes:

  attributes to extract. If NULL, returns text.

- all:

  if TRUE, all selectors are collected. Otherwise, only the first
  non-empty result is used.

- n:

  if multiple are found, how many to return

## Value

a vector of max length n
