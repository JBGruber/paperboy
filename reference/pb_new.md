# Create new scraper

Create new scraper

## Usage

``` r
pb_new(np, author = "", issue = "")
```

## Arguments

- np:

  domain or a URL of the newspaper this scraper is for.

- author:

  who wrote it.

- issue:

  is there a GitHub issue?

## Examples

``` r
if (FALSE) { # \dontrun{
paperboy:::pb_new(np = "https://www.buzzfeed.com/",
                  author = "[@JBGruber](https://github.com/JBGruber/)")

paperboy:::pb_new_done()
} # }
```
