# Fix a Broken paperboy Parser

Repair a broken newspaper parser in the `paperboy` R package.

- If an argument is given, fix the parser for that domain: **$ARGUMENTS**
- If no argument is given, download the monitoring data and target the **first broken parser** in the list.

The health dashboard runs daily and writes results to a SQLite database in the
[paperboy-pulse](https://github.com/sina-chen/paperboy-pulse) repo. This command pulls that
database to decide what to fix.

> **Scope — strictly one parser per invocation.** This command works on **exactly one** domain: the
> argument, or the first candidate when no argument is given. Once that domain is chosen, never switch
> to a different domain and never move on to the "next" broken parser — not even if the chosen one turns
> out to be unfixable, already healthy, or a non-parser problem. Whenever you cannot complete the fix,
> **stop, explain why, suggest how it might be addressed, and wait for the user.** If the user wants to
> work on another domain, they will say so in a new prompt.

Work through the steps below in order. Use `Rscript` for all R operations and `sqlite3` for
database queries — no interactive session is needed. Read each command's output before continuing.

---

## Step 1 — Validate environment

```bash
Rscript -e "cat(file.exists('DESCRIPTION') && any(grepl('Package: paperboy', readLines('DESCRIPTION'), fixed = TRUE)), '\n')"
```

If the output is not `TRUE`, stop and tell the user to run this command from the paperboy repository root.

---

## Step 2 — Download the monitoring database

```bash
curl -fsSL https://raw.githubusercontent.com/sina-chen/paperboy-pulse/main/data/paperboy_monitor.sqlite -o /tmp/paperboy_monitor.sqlite && echo "downloaded $(stat -c%s /tmp/paperboy_monitor.sqlite) bytes"
```

If the download fails, stop and report it — the rest of the command depends on this file.

The database has two tables:

- `test_runs(run_id, started_at, completed_at, n_domains, status)`
- `domain_results(run_id, domain, tested_at, n_articles_attempted, n_http_success, pct_datetime, pct_author, pct_headline, pct_text, health, error_msg)`

`health` is one of `ok`, `degraded`, `broken`, `error`. The `pct_*` columns give the per-field
extraction success rate (0–1) for the last run; `error_msg` explains hard failures.

---

## Step 3 — Choose the target domain

**If `$ARGUMENTS` is non-empty**, set `{domain}` to it (strip any leading `www.` and any URL path —
you want the bare registrable domain, e.g. `faz.net`). Confirm it appears in the latest run:

```bash
sqlite3 /tmp/paperboy_monitor.sqlite "
SELECT domain, n_http_success, pct_datetime, pct_author, pct_headline, pct_text, health, error_msg
FROM domain_results
WHERE run_id = (SELECT run_id FROM test_runs WHERE status='completed' ORDER BY started_at DESC LIMIT 1)
  AND domain = '$ARGUMENTS';
"
```

**If `$ARGUMENTS` is empty**, take the first broken/degraded parser, ordered by domain:

```bash
sqlite3 -header -column /tmp/paperboy_monitor.sqlite "
SELECT domain, n_http_success, pct_datetime, pct_author, pct_headline, pct_text, health, error_msg
FROM domain_results
WHERE run_id = (SELECT run_id FROM test_runs WHERE status='completed' ORDER BY started_at DESC LIMIT 1)
  AND health IN ('broken','degraded')
ORDER BY domain
LIMIT 1;
"
```

Set `{domain}` to that single row and **commit to it** — this is the one parser you will work on for
the rest of this invocation. Do not query for or consider any other domain. Tell the user which domain
you selected, including the per-field percentages.

---

## Step 4 — Classify the failure mode

Look at `error_msg` and the `pct_*` columns for `{domain}` and decide what kind of fix is needed:

- **`Parser returned no results`**, or some `pct_*` columns near `0` while others are high: this is a
  **selector problem** — the main case this command handles. The low `pct_*` columns tell you exactly
  which fields' selectors broke (e.g. `pct_text = 0` → the text container selector no longer matches).
  Record the failing field(s) as your fix targets and continue to Step 5.
- **`All HTTP requests failed`** (and `n_http_success = 0`): the site is blocking requests or the test
  URLs are stale — usually **not** fixable by editing selectors. Re-collect in Step 6; if collection
  also fails locally, **stop** and report that this domain needs a transport-level fix (headers, cookies,
  blocking) rather than a parser change.
- **`No article URLs found in RSS feed`** (`n_articles_attempted = 0`): the RSS feed is dead. Find a
  **new feed** in Step 6 (see `new-parser` Step 4 for the discovery procedure) and update `rss` in
  `inst/status.csv` in Step 11.
- **Field genuinely absent on the site** — one field stays at `0` because the site simply does not
  publish it (e.g. a broadcaster that never bylines authors, so `pct_author = 0` and the page has no
  author anywhere). This is **not** a selector bug. **Stop** and discuss with the user: explain that the
  field is absent on the page, and propose options such as hardcoding a sensible constant (e.g.
  `author = "3sat"`), leaving it `NA`, or — if they disagree — pointing you at where the value actually
  lives. Apply only what the user agrees to.

**Do not abandon `{domain}` and pick a different parser.** If `{domain}` is
not fixable by this command, stop at this step, lay out the situation and your suggested options, and
wait for the user's decision. Continuing to another domain on your own is never correct.

---

## Step 5 — Locate the existing parser file

```bash
Rscript -e "devtools::load_all(quiet = TRUE); cat(paperboy:::classify('{domain}'), '\n')"
```

Record this as `{domain_class}` (e.g. `faz_net`). The parser is `R/deliver_{domain_class}.R` and the
function is `pb_deliver_paper.{domain_class}`. Confirm the file exists:

```bash
ls -l R/deliver_{domain_class}.R
```

If it does not exist, this is not an existing parser — stop and suggest running `new-parser` for this
domain instead. Otherwise read the current parser so you know what to change:

```bash
cat R/deliver_{domain_class}.R
```

---

## Step 6 — Re-collect fresh test articles

Get the recorded feed from `status.csv`:

```bash
Rscript -e "s <- read.csv('inst/status.csv', stringsAsFactors = FALSE); cat(s\$rss[s\$domain == '{domain}'], '\n')"
```

Record it as `{rss_url}` and collect:

```bash
Rscript -e "
devtools::load_all(quiet = TRUE)
test_data <- pb_collect('{rss_url}')
saveRDS(test_data, '/tmp/pb_fix_data.rds')
cat('Collected', nrow(test_data), 'articles\n')
"
```

If the feed is empty/dead (the `No article URLs found` case) or no feed is recorded, find a working
feed with `pb_find_rss('{domain}')`, or by appending `/feed`, `/rss`, or `/index.xml` to the root
domain and testing each with `pb_collect()`, or via a web search. Record the working feed as
`{rss_url}` for Step 11. If only specific article URLs are obtainable, collect those instead.

If collection fails entirely (HTTP-block case), stop and report per Step 4.

---

## Step 7 — Analyse the current HTML structure

The site's markup has changed since the parser was written — find what it looks like now:

```bash
Rscript -e "
devtools::load_all(quiet = TRUE)
test_data <- readRDS('/tmp/pb_fix_data.rds')
pb_html_context(test_data, n = 3L)
"
```

Read the output carefully and identify replacement selectors **for the failing fields only**, using the
same priority order as `new-parser` Step 6:

- **`datetime`**: `article:published_time`/`og:updated_time` meta → JSON-LD `datePublished` → `<time datetime>`
- **`headline`**: `og:title` meta → JSON-LD `headline` → an `h1.some-class`
- **`author`**: `article:author`/`author` meta → JSON-LD `author.name` → a byline/author-class element
- **`text`**: top-ranked entry from "Most Common `<p>` Parents" as the container (e.g. `div.article-body > p`); fall back to bare `p` via `html_search(all = FALSE)`

Prefer `html_search()` with a fallback list — it keeps the parser robust across templates. See the
[existing parsers](https://github.com/JBGruber/paperboy/tree/main/R) for examples.

---

## Step 8 — Edit the parser file

Edit `R/deliver_{domain_class}.R`, replacing only the selectors for the fields you identified as broken.
Leave working fields untouched. Keep the existing conventions:

- All four fields (`datetime`, `author`, `headline`, `text`) must still be extracted.
- `datetime` passed through `lubridate::as_datetime()`.
- `author` ends with `toString()`.
- `text` joins paragraphs with `paste(collapse = "\n")`.
- Return `s_n_list(datetime, author, headline, text)` (extra fields land in `misc`).
- Do not add comments beyond the four field-label comments.

---

## Step 9 — Test and iterate (up to 3 rounds)

```bash
Rscript -e "
devtools::load_all(quiet = TRUE)
result <- pb_deliver(readRDS('/tmp/pb_fix_data.rds'))
total  <- nrow(result)
rates  <- c(
  datetime = sum(is.na(result\$datetime)) / total,
  author   = (sum(result\$author == 'NA', na.rm = TRUE) + sum(is.na(result\$author))) / total,
  headline = (sum(result\$headline == '', na.rm = TRUE) + sum(is.na(result\$headline))) / total,
  text     = sum(result\$text == '', na.rm = TRUE) / total
)
cat(paste0(names(rates), ': ', round(rates * 100, 1), '%'), sep = '\n')
"
```

A field **passes** when its failure rate is below 5 %. If any field still fails:

1. Re-read the HTML context from Step 7.
2. Adjust the failing selector.
3. Re-run this test step.

Repeat up to 3 times. If the parser still fails after 3 rounds, stop, report the per-field failure rates,
and do **not** commit.

---

## Step 10 — Manual field review

```bash
Rscript -e "
devtools::load_all(quiet = TRUE)
test_data <- readRDS('/tmp/pb_fix_data.rds')
result    <- pb_deliver(test_data[1, ])
cat('URL:\n', test_data\$url[1], '\n\n')
cat('datetime: ', format(result\$datetime), '\n\n')
cat('author:   ', result\$author, '\n\n')
cat('headline: ', result\$headline, '\n\n')
cat('text:\n', result\$text, '\n')
"
```

Show this output to the user and ask them to open the URL and verify each field matches the page.

**If the user reports problems:** ask which fields are wrong and what the correct values should be,
identify better selectors from the Step 7 context (check for sub-headlines, sidebars, related-article
blocks, or nested ad content), fix the file, re-run Step 9, then repeat this review. Only proceed once
the user explicitly confirms the fields look correct.

---

## Step 11 — Update `inst/status.csv`

Set the badge back to gold, and update the `rss` feed if you found a new one in Step 6:

```bash
Rscript -e "
status <- read.csv('inst/status.csv', stringsAsFactors = FALSE)
domain <- '{domain}'
rss    <- '{rss_url}'
badge  <- '![](https://img.shields.io/badge/status-gold-%23ffd700.svg)'
status[status\$domain == domain, 'status'] <- badge
if (nzchar(rss) && !is.na(rss)) status[status\$domain == domain, 'rss'] <- rss
status <- status[order(status\$domain), ]
write.csv(status, 'inst/status.csv', row.names = FALSE)
cat('status.csv updated\n')
"
```

---

## Step 12 — Commit (do not push)

```bash
git add R/deliver_{domain_class}.R inst/status.csv
git commit -m "fix: repair parser for {domain}"
```

---

## Final report

Tell the user:
- Which domain was fixed and the parser function name
- What was broken (failure mode from Step 4) and which selectors you changed
- Per-field pass/fail rates from the last test run
- Whether the RSS feed was changed in `status.csv`
- That the commit is local and ready to push as a pull request when they are happy with it
