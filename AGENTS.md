# paperboy

> A community repository of news media scrapers for R

## Overview

paperboy is an R package that collects article HTML from news websites and parses it into a tidy data frame with four required fields: `datetime`, `author`, `headline`, and `text`. Each supported news site has its own parser, contributed by the community. The package is intentionally a thin coordination layer: almost all interesting code lives in the individual parser files.

## Quick Reference

- **Project type:** R package
- **Language:** R (≥ 4.1.0)
- **~180 parsers** in `R/deliver_*.R`, one per supported domain
- **Entry points for users:** `pb_collect()` → `pb_deliver()`
- **Entry point for contributors:** `use_new_parser()` or `/new-parser <URL>` (Claude Code)
- **Daily health monitoring:** [paperboy-pulse dashboard](https://sina-chen.github.io/paperboy-pulse/)

## Architecture

### S3 dispatch

`pb_deliver()` dispatches to individual parsers via S3 on a class derived from the article URL:

```
https://www.buzzfeed.com/article → class "www_buzzfeed_com" → pb_deliver_paper.www_buzzfeed_com()
```

The class name is produced by `paperboy:::classify(adaR::ada_get_domain(url))`, which lowercases the domain and replaces `.` and `-` with `_`. Every parser is therefore a single S3 method with a predictable name.

When no specific parser exists, `pb_deliver_paper.default` (the generic parser) is used as a fallback.

### One file per parser

Each parser lives in `R/deliver_{domain_class}.R` — for example, `R/deliver_www_buzzfeed_com.R`. The file contains exactly one exported function.

### Template

`inst/templates/deliver_.R` is the canonical starting point. `use_new_parser()` copies it and substitutes `{{newspaper}}` with the domain class string.

## Parser Anatomy

A minimal parser looks like this:

```r
#' @export
pb_deliver_paper.www_example_com <- function(x, verbose = NULL, pb, ...) {

  pb_tick(x, verbose, pb)                        # progress bar — always keep this
  html <- rvest::read_html(x$content_raw)        # x$content_raw is the raw HTML string

  datetime <- html %>%
    rvest::html_element("[property='article:published_time']") %>%
    rvest::html_attr("content") %>%
    lubridate::as_datetime()

  headline <- html %>%
    rvest::html_element("[property='og:title']") %>%
    rvest::html_attr("content")

  author <- html %>%
    rvest::html_element(".byline-author") %>%
    rvest::html_text2() %>%
    toString()                                   # always collapse to one string

  text <- html %>%
    rvest::html_elements(".article-body > p") %>%
    rvest::html_text2() %>%
    paste(collapse = "\n")

  s_n_list(datetime, author, headline, text)     # always the last line
}
```

### Rules

- `datetime` **must** pass through `lubridate::as_datetime()`.
- `author` **must** end with `toString()` to produce a single string.
- `text` **must** join paragraphs with `paste(collapse = "\n")`.
- `s_n_list()` is always the return value. It ensures every element is length-1 and converts `NULL` to `NA`. Extra fields beyond the four required ones are automatically moved to the `misc` column.
- Do not add comments beyond the four field-label comments; the template already includes them.

## Helper Functions

### `html_search(html, selectors, attributes, all, n)`

Tries a list of CSS selectors in order and returns the first non-empty result. Essential for sites that use different templates for different article types:

```r
headline <- html %>%
  html_search(
    selectors  = c("[property='og:title']", "h1.article-title", "h1"),
    attributes = c("content", "text")
  )
```

Use `all = FALSE` (default) to return only the first non-empty match. Set `n = Inf` for multi-node fields like paragraphs.

### `pb_html_context(x, n = 1L)`

Prints a compact text summary of collected HTML for use in non-interactive environments (e.g. LLM agents, CI). Use it instead of `pb_inspect()` when a browser is not available:

```r
test_data <- pb_collect("https://example.com/feed")
pb_html_context(test_data, n = 3L)
```

Output sections: meta tags, JSON-LD blocks, `<time>` elements, most-common `<p>` parent selectors, and elements whose class names contain `author`, `byline`, `headline`, etc.

### `pb_inspect(x, i)`

Opens article `i` from collected data in a browser for interactive inspection. Human-facing alternative to `pb_html_context()`.

## Adding a New Parser

### Selector priority

| Field | First choice | Fallback |
|-------|-------------|---------|
| `datetime` | `article:published_time` meta → `html_attr("content")` | `<time datetime="...">` → `html_attr("datetime")` |
| `headline` | `og:title` meta → `html_attr("content")` | `h1` with keyword class |
| `author` | `article:author` meta or JSON-LD `author.name` | element with `author`/`byline` class → `html_text2()` |
| `text` | most-frequent `<p>` parent from `pb_html_context()` output | bare `p` as fallback via `html_search()` |

### Workflow (automated)

If using Claude Code inside this repository, run:

```
/new-parser https://www.example.com/some-article/
```

This command handles all steps automatically: RSS discovery, test data collection, HTML analysis via `pb_html_context()`, parser writing, iterative testing, `status.csv` update, and a local commit ready for review.

The `/new-parser` and `/fix-parser` commands run all R through a persistent R session exposed by the [btw](https://posit-dev.github.io/btw/) package's MCP server (configured in `.mcp.json`). This keeps them cross-platform (no `/tmp`, no `Rscript -e` subprocesses, no `sqlite3` CLI). On first use, install the packages — `install.packages(c("btw", "RSQLite"))` — and approve the `r-btw` server when Claude Code prompts.

### Workflow (manual)

```r
# 1. Find the RSS feed
pb_find_rss("https://www.example.com")

# 2. Create the parser file and open it for editing (first run)
use_new_parser(
  x      = "https://www.example.com/some-article/",
  author = "[@yourname](https://github.com/yourname/)",
  rss    = "https://www.example.com/feed"
)

# 3. Edit R/deliver_www_example_com.R, then test (subsequent runs)
use_new_parser(
  x         = "https://www.example.com/some-article/",
  author    = "[@yourname](https://github.com/yourname/)",
  rss       = "https://www.example.com/feed",
  test_data = pb_collect("https://www.example.com/feed")
)
```

`use_new_parser()` runs multiple times: the first run creates and opens the file; subsequent runs test and, on success, update `inst/status.csv`.

## Testing

A parser passes when each required field (`datetime`, `author`, `headline`, `text`) parses successfully for ≥ 95 % of test articles. The internal `test_parser()` function enforces this threshold.

To test manually during development:

```r
devtools::load_all()
test_data  <- pb_collect("https://www.example.com/feed")
result     <- pb_deliver(test_data)
```

The extended parser test suite runs daily in CI using the RSS URL from `inst/status.csv`. Enable it locally by setting `PB_TEST_PARSER=true`.

## `inst/status.csv`

Tracks every parser. Columns:

| Column | Content |
|--------|---------|
| `domain` | bare domain, no `www.` (e.g. `buzzfeed.com`) — alphabetically sorted |
| `status` | shields.io badge HTML; `gold` = working, `requested` = placeholder |
| `author` | Markdown link to the contributor's GitHub profile |
| `issues` | Markdown link to the associated GitHub issue (optional) |
| `rss` | RSS/Atom feed URL used for daily CI testing |

`use_new_parser()` writes this file automatically. If editing by hand, keep the rows sorted by `domain`.

## Development Commands

```r
devtools::load_all()    # load all parsers including newly written ones
devtools::test()        # run the test suite
devtools::document()    # regenerate man/ from roxygen comments
pb_available()          # list all domains with a parser
pb_available("https://www.example.com")  # TRUE/FALSE for a specific URL
```
