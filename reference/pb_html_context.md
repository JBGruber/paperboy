# Get HTML context for LLM-assisted parser development

A text-output alternative to
[pb_inspect](https://jbgruber.github.io/paperboy/reference/pb_inspect.md)
for non-interactive environments such as LLM agents. Prints a compact
structured summary of page HTML — meta tags, JSON-LD blocks, `<time>`
elements, most common paragraph-parent selectors, and elements with
keyword-bearing class names — to help identify CSS selectors for the
four required parser fields without needing a browser.

## Usage

``` r
pb_html_context(x, n = 1L)
```

## Arguments

- x:

  A data frame from
  [pb_collect](https://jbgruber.github.io/paperboy/reference/pb_collect.md).

- n:

  Integer; number of articles to summarise (default `1L`).

## Value

Invisibly returns a character vector of summaries (one per article).
Prints to the console as a side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
test_data <- pb_collect("https://denverpost.com/feed")
pb_html_context(test_data, n = 3L)
} # }
```
