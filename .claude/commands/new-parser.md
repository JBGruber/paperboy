# Add a New paperboy Parser

Add a new newspaper parser to the `paperboy` R package for: **$ARGUMENTS**

Work through the steps below in order. Read each tool result before continuing to the next step.

---

## Environment & tools

Run **every** R operation through the **`run_r`** tool exposed by the **`r-btw`** MCP server (the btw
package). This is a *single persistent R session*: variables you create — most importantly the collected
test data — stay in memory between calls, so there is no need to write anything to disk or to `/tmp`.
This is what makes the command portable to Windows.

- **R code** → the `run_r` tool. Never call `Rscript` on the command line.
- **Reading and editing files** → Claude Code's own `Read` / `Write` / `Edit` tools.
- **`git`** → the `Bash` tool (git is cross-platform).

If the `run_r` tool is not available, the MCP server is not connected. Tell the user to install btw
(`install.packages("btw")`) and restart Claude Code so it picks up `.mcp.json`, then approve the
`r-btw` server when prompted. Stop until it is available. (RSQLite is only needed by `fix-parser`,
not here.)

---

## Step 1 — Validate environment

Run via `run_r`:

```r
file.exists("DESCRIPTION") && any(grepl("Package: paperboy", readLines("DESCRIPTION"), fixed = TRUE))
```

If the result is not `TRUE`, stop and tell the user to start Claude Code from the paperboy repository
root (the persistent R session inherits that working directory).

Otherwise load the package once — it stays loaded for the rest of this session:

```r
devtools::load_all(quiet = TRUE)
```

---

## Step 2 — Check for duplicate

Run via `run_r`:

```r
pb_available("$ARGUMENTS")
```

If the result is `TRUE`, a parser already exists. Report this to the user and stop.

---

## Step 3 — Determine the domain class name

This is the string that becomes the function name and the file name. Run via `run_r`:

```r
paperboy:::classify(adaR::ada_get_domain("$ARGUMENTS"))
```

Record this value as `{domain_class}` (e.g. `www_denverpost_com`). The parser file will be
`R/deliver_{domain_class}.R` and the function will be `pb_deliver_paper.{domain_class}`.

Also record the bare domain without `www.`:

```r
sub("^www\\.", "", adaR::ada_get_domain("$ARGUMENTS"))
```

Record this as `{domain}` (e.g. `denverpost.com`).

---

## Step 4 — Find the RSS feed

Run via `run_r`:

```r
pb_find_rss("$ARGUMENTS")
```

Record the URL as `{rss_url}`. If nothing is found, try appending `/feed`, `/rss`, or `/index.xml` to
the site's root domain and test each with `pb_collect()`. If these don't find a RSS URL, try a web
search. If no working feed exists, set `{rss_url}` to `NA`.

---

## Step 5 — Collect test articles

Run via `run_r`. The result stays in memory as `test_data` — no need to save it:

```r
test_data <- pb_collect("{rss_url}")
nrow(test_data)
```

If `{rss_url}` is NA, collect individual article URLs from the `$ARGUMENTS` domain into `test_data`
instead.

---

## Step 6 — Analyse the HTML structure

Run via `run_r`:

```r
pb_html_context(test_data, n = 3L)
```

Read the output carefully. Identify selectors for each of the four required fields using this priority order:

**`datetime`**
1. `article:published_time` or `og:updated_time` meta tag → `html_element('[property="article:published_time"]') %>% html_attr("content")`
2. `datePublished` field inside a JSON-LD block → parse with `jsonlite::fromJSON()`
3. A `<time datetime="...">` element → `html_element("time") %>% html_attr("datetime")`

**`headline`**
1. `og:title` meta tag → `html_element('[property="og:title"]') %>% html_attr("content")`
2. `headline` field in JSON-LD
3. The keyword-class element section may show an `h1.some-class` to use directly

**`author`**
1. `article:author` or `author` meta tag → `html_attr("content")`
2. `author.name` in JSON-LD
3. An element from the keyword-class section with "author" or "byline" in its class → `html_text2() %>% toString()`

**`text`**
- Use the top-ranked entry from "Most Common `<p>` Parents" as the container selector, e.g. `div.article-body > p`
- Fall back to bare `p` using `html_search()` with `all = FALSE`

Use `html_search()` with a fallback list wherever reasonable — it makes parsers more robust across article templates. See the [existing parsers](https://github.com/JBGruber/paperboy/tree/main/R) for examples.

---

## Step 7 — Write the parser file

Read the template with the `Read` tool:

```
inst/templates/deliver_.R
```

Write `R/deliver_{domain_class}.R` (with the `Write` tool) using the selectors you identified in
Step 6. Follow these conventions:

- All four fields (`datetime`, `author`, `headline`, `text`) must be extracted.
- `datetime` must be passed through `lubridate::as_datetime()`.
- `author` must end with `toString()` to produce a single string.
- `text` should join paragraphs with `paste(collapse = "\n")`.
- Return `s_n_list(datetime, author, headline, text)`. Additional fields are allowed; they land in the `misc` column automatically.
- Do not add comments beyond the four field-label comments already in the template.

---

## Step 8 — Test and iterate (up to 3 rounds)

After writing the file, reload the package and run the parser on the test data — all via `run_r`.
Because the session is persistent, `test_data` is still in memory:

```r
devtools::load_all(quiet = TRUE)
result <- pb_deliver(test_data)
total  <- nrow(result)
rates  <- c(
  datetime = sum(is.na(result$datetime)) / total,
  author   = (sum(result$author == "NA", na.rm = TRUE) + sum(is.na(result$author))) / total,
  headline = (sum(result$headline == "", na.rm = TRUE) + sum(is.na(result$headline))) / total,
  text     = sum(result$text == "", na.rm = TRUE) / total
)
cat(paste0(names(rates), ": ", round(rates * 100, 1), "%"), sep = "\n")
```

A field **passes** when its failure rate is below 5 %. If any field fails:

1. Re-read the HTML context from Step 6.
2. Adjust the failing selector in the parser file with the `Edit` tool.
3. Re-run this test step (the `devtools::load_all()` picks up your edits).

Repeat up to 3 times. If the parser still fails after 3 rounds, stop, report the per-field failure rates, and do **not** commit.

---

## Step 9 — Manual field review

Run via `run_r`:

```r
result <- pb_deliver(test_data[1, ])
report_file <- paste0(result$domain, ".txt")
c(
  "URL:\n", result$url, "\n\n",
  "datetime: ", format(result$datetime), "\n\n",
  "author:   ", result$author, "\n\n",
  "headline: ", result$headline, "\n\n",
  "text:\n", result$text, "\n"
) |> 
  writeLines(report_file)
cat("Result written to ", report_file)
```

Show the file with the output (`report_file`) to the user and ask them to open the URL and verify each field matches the page.

**If the user reports problems:**
- Ask which fields are wrong and (if they can tell) what the correct values should be.
- Identify better selectors from the HTML context captured in Step 6. Check whether the wrong field came from a sub-headline, a sidebar, a related-article block, or nested ad content — these are the most common sources of error.
- Fix the parser file, re-run the automated test (Step 8), then repeat this review step.

Only proceed to Step 10 once the user explicitly confirms the fields look correct.

---

## Step 10 — Update `inst/status.csv`

Run via `run_r`:

```r
status <- read.csv("inst/status.csv", stringsAsFactors = FALSE)
domain <- "{domain}"
rss    <- "{rss_url}"
badge  <- "![](https://img.shields.io/badge/status-gold-%23ffd700.svg)"
if (!domain %in% status$domain) {
  status <- rbind(status, data.frame(
    domain = domain, status = badge,
    author = "LLM agent", issues = "", rss = rss,
    stringsAsFactors = FALSE
  ))
} else {
  status[status$domain == domain, "status"] <- badge
  status[status$domain == domain, "rss"]    <- rss
}
status <- status[order(status$domain), ]
write.csv(status, "inst/status.csv", row.names = FALSE)
cat("status.csv updated\n")
```

---

## Step 11 — Commit (do not push)

Use the `Bash` tool:

```bash
git add R/deliver_{domain_class}.R inst/status.csv
git commit -m "feat: add parser for {domain}"
```

---

## Final report

Tell the user:
- Which site was parsed and what the parser function is named
- Per-field pass/fail rates from the last test run
- The RSS feed URL that was added to `status.csv` (or `NA` if none found)
- That the commit is local and ready to push as a pull request when they are happy with it
