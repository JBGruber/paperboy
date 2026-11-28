# Add a New paperboy Parser (as a Pull Request)

Add a new newspaper parser to the `paperboy` R package for: **$ARGUMENTS**

The parser is developed on its own branch and submitted as a GitHub pull request. The PR description
contains a report of the parser and the test results, so the review happens on GitHub, not locally.

Work through the steps below in order. Read each tool result before continuing to the next step.

---

## Environment & tools

Run **every** R operation through the **`run_r`** tool exposed by the **`r-btw`** MCP server (the btw
package). This is a *single persistent R session*: variables you create — most importantly the collected
test data — stay in memory between calls, so there is no need to write anything to disk or to `/tmp`.
This is what makes the command portable to Windows.

- **R code** → the `run_r` tool. Never call `Rscript` on the command line.
- **Reading and editing files** → Claude Code's own `Read` / `Write` / `Edit` tools.
- **`git`** and **`gh`** → the `Bash` tool (both are cross-platform).

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

Then check git and the GitHub CLI with the `Bash` tool:

```bash
git status --porcelain
gh auth status
```

- If `git status --porcelain` prints anything, the working tree is not clean. Stop and ask the user to
  commit or stash their changes first.
- If `gh auth status` fails, stop and tell the user to run `! gh auth login`.

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

## Step 4 — Create a branch

Use the `Bash` tool to start a fresh branch from an up-to-date `main`:

```bash
git checkout main
git pull --ff-only
git checkout -b new-parser/{domain_class}
```

If the branch already exists (locally or on `origin`), stop and tell the user — a PR for this parser
is probably already open.

---

## Step 5 — Find the RSS feed

Run via `run_r`:

```r
pb_find_rss("$ARGUMENTS")
```

Record the URL as `{rss_url}`. If nothing is found, try appending `/feed`, `/rss`, or `/index.xml` to
the site's root domain and test each with `pb_collect()`. If these don't find a RSS URL, try a web
search. If no working feed exists, set `{rss_url}` to `NA`.

---

## Step 6 — Collect test articles

Run via `run_r`. The result stays in memory as `test_data` — no need to save it:

```r
test_data <- pb_collect("{rss_url}")
nrow(test_data)
```

If `{rss_url}` is NA, collect individual article URLs from the `$ARGUMENTS` domain into `test_data`
instead.

---

## Step 7 — Analyse the HTML structure

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

Check whether a field might come from a sub-headline, a sidebar, a related-article block, or nested ad
content — these are the most common sources of error, and there is no local human review in this
workflow to catch them.

---

## Step 8 — Write the parser file

Read the template with the `Read` tool:

```
inst/templates/deliver_.R
```

Write `R/deliver_{domain_class}.R` (with the `Write` tool) using the selectors you identified in
Step 7. Follow these conventions:

- All four fields (`datetime`, `author`, `headline`, `text`) must be extracted.
- `datetime` must be passed through `lubridate::as_datetime()`.
- `author` must end with `toString()` to produce a single string.
- `text` should join paragraphs with `paste(collapse = "\n")`.
- Return `s_n_list(datetime, author, headline, text)`. Additional fields are allowed; they land in the `misc` column automatically.
- Do not add comments beyond the four field-label comments already in the template.

---

## Step 9 — Test and iterate (up to 3 rounds)

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

1. Re-read the HTML context from Step 7.
2. Adjust the failing selector in the parser file with the `Edit` tool.
3. Re-run this test step (the `devtools::load_all()` picks up your edits).

Repeat up to 3 times. If the parser still fails after 3 rounds, stop, report the per-field failure
rates, and do **not** commit or open a PR. Switch back with `git checkout main` and leave the branch
and the uncommitted parser file in place for the user to inspect (tell them so).

---

## Step 10 — Update `inst/status.csv`

Run via `run_r`:

```r
devtools::document()
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

## Step 11 — Build the PR report

Newspaper articles are copyrighted, so the report must **never** contain the full article text. For
`text`, show only the first 3 and the last 4 words, plus the word count.

Run via `run_r` (`result`, `rates` and `total` are still in memory from Step 9):

```r
snippet <- function(txt) {
  if (is.na(txt) || !nzchar(trimws(txt))) return("*(empty)*")
  w <- strsplit(trimws(txt), "\\s+")[[1]]
  if (length(w) <= 7) return(sprintf("%s (%d words)", paste(w, collapse = " "), length(w)))
  sprintf("%s … %s (%d words)",
          paste(head(w, 3), collapse = " "), paste(tail(w, 4), collapse = " "), length(w))
}
md_cell <- function(x) gsub("|", "\\|", gsub("[\r\n]+", " ", as.character(x)), fixed = TRUE)

rate_rows <- sprintf("| `%s` | %.1f %% | %s |", names(rates), rates * 100,
                     ifelse(rates < 0.05, "✅ pass", "❌ fail"))

samples <- result[seq_len(min(3L, nrow(result))), ]
sample_blocks <- vapply(seq_len(nrow(samples)), function(i) {
  s <- samples[i, ]
  paste0(
    "### Sample ", i, "\n\n",
    "URL: ", s$url, "\n\n",
    "| field | value |\n|---|---|\n",
    "| datetime | ", md_cell(format(s$datetime)), " |\n",
    "| author | ", md_cell(s$author), " |\n",
    "| headline | ", md_cell(s$headline), " |\n",
    "| text | ", md_cell(snippet(s$text)), " |\n"
  )
}, character(1))

pr_body <- c(
  "## New parser: `{domain}`",
  "",
  "- Function: `pb_deliver_paper.{domain_class}` in `R/deliver_{domain_class}.R`",
  "- RSS feed (added to `inst/status.csv`): {rss_url}",
  paste0("- Test articles: ", total),
  "",
  "## Test results",
  "",
  "A field passes when its failure rate is below 5 %.",
  "",
  "| field | failure rate | result |",
  "|---|---|---|",
  rate_rows,
  "",
  "## Sample output",
  "",
  "Please open each URL and check that the fields match the page. To respect copyright, `text` only",
  "shows the first 3 and last 4 words.",
  "",
  sample_blocks
)
pr_body_file <- normalizePath(tempfile(fileext = ".md"), winslash = "/", mustWork = FALSE)
writeLines(pr_body, pr_body_file, useBytes = TRUE)
cat(pr_body, sep = "\n")
cat("\nPR body written to:", pr_body_file, "\n")
```

Look over the printed report. If a sample shows an obviously wrong field (e.g. a site name as the
author, a teaser instead of the headline, text that starts or ends with boilerplate), go back to
Step 9 and fix it before opening the PR.

---

## Step 12 — Commit, push and open the PR

Use the `Bash` tool, substituting the path printed as `pr_body_file`:

```bash
git add R/deliver_{domain_class}.R inst/status.csv
git commit -m "feat: add parser for {domain}"
git push -u origin new-parser/{domain_class}
gh pr create --base main --head new-parser/{domain_class} \
  --title "feat: add parser for {domain}" \
  --body-file "{pr_body_file}"
```

Then switch back to `main` so the next `/new-parser-pr` run starts from a clean state:

```bash
git checkout main
```

---

## Final report

Tell the user:
- Which site was parsed and what the parser function is named
- Per-field pass/fail rates from the last test run
- The RSS feed URL that was added to `status.csv` (or `NA` if none found)
- The URL of the pull request, and that the sample output in its description should be checked
  against the linked articles before merging
