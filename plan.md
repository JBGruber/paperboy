# Plan: LLM-assisted Parser Contribution for paperboy

## Context

The paperboy package is a community repository of news-media scrapers. The goal is to open it to LLM agents so that adding a new parser requires minimal human effort. The current developer workflow is embodied in `use_new_parser()` (`R/utils_dev.R`), which:

1. Creates an R file from `inst/templates/deliver_.R` (with `{{newspaper}}` substitution)
2. Finds the RSS feed via `pb_find_rss()`
3. Writes an entry to `inst/status.csv`
4. Tests consistency (`test_parser_consistency`) and field coverage (`test_parser`)
5. Marks the CSV status "gold" on success

The hard human step is step 4: opening the HTML in a browser (`pb_inspect()`) to identify CSS selectors for datetime, headline, author, and text. An LLM can replace this if it can read the HTML and reason about structure.

The vignette (`vignettes/For_Developers.Rmd`) still references the old `pb_new()` API; `demo_paperboy.qmd` has the up-to-date flow.

---

## Recommended Approach: Three-Part Implementation

### Part 1 — Update `vignettes/For_Developers.Rmd`

The vignette must be current before pointing anyone (human or LLM) to it.

Changes needed:
- Replace `paperboy:::pb_new(np = "…")` with `use_new_parser(x = "…", author = "…", rss = …)`
- Replace the old mediacloud API example with the `httr2`-based one from `demo_paperboy.qmd`
- Replace `articles_raw <- pb_collect(test_data$url[1:20])` flow with the RSS-first flow
- Keep (and expand) the `html_search()` and `s_n_list()` explanations — these are still accurate
- Add a short "Automated Testing" section explaining the daily RSS-based CI job and `status.csv`
- Add a new "Contributing via LLM" section pointing to the Claude Code skill (Part 3)

---

### Part 2 — Add `pb_html_context()` helper function

`pb_inspect()` renders a browser tab — useless to an LLM. We need a text-output companion.

New exported function `pb_html_context(x, n = 1L)` in `R/utils_dev.R`:
- Takes the output of `pb_collect()` (same interface as `pb_inspect()`)
- Parses each article's `content_raw` with `rvest::read_html()`
- Extracts and returns a structured summary as a character string (or prints it):
  - All `<meta>` tags (name/property + content) — covers OpenGraph, schema.org dates/authors
  - All unique element+class combinations found in the document (e.g., `time.article-time`, `span.author-name`)
  - The first 3 `<time>` elements with their attributes
  - The 5 most-frequent paragraph-parent CSS paths (to identify the article body class)
  - Any `<script type="application/ld+json">` structured data blocks

This is the LLM-readable substitute for `pb_inspect()`. It compresses a 200 KB HTML page into ~2 KB of structured hints that point directly to the right selectors.

---

### Part 3 — Claude Code custom slash command `.claude/commands/new-parser.md`

A Markdown file that Claude Code exposes as `/new-parser <URL>`. When invoked:

```
/new-parser https://www.denverpost.com/some-article/
```

The file instructs Claude to execute this workflow autonomously:

1. **Validate environment**: confirm we're in the paperboy repo (`file.exists("DESCRIPTION")`)
2. **Normalize URL**: extract domain, check `pb_available()` to avoid duplicates
3. **Find RSS**: run `Rscript -e "cat(paperboy::pb_find_rss('DOMAIN'))"` → capture URL
4. **Collect test data**: run `Rscript -e` to call `pb_collect(rss_url)` and `saveRDS()` to a temp file
5. **Inspect HTML**: run `Rscript -e` to call `paperboy::pb_html_context(test_data, n = 3L)` and print to stdout → Claude reads this output to identify selectors
6. **Write parser**: use the template (`inst/templates/deliver_.R`) as a base, fill in the CSS selectors identified in step 5, write to `R/deliver_{domain}.R`
7. **Test loop** (up to 3 iterations):
   - Run `Rscript -e "devtools::load_all(); paperboy:::test_parser(readRDS('…'))"` and capture output
   - If >5% failure rate on any field: re-read the HTML context, adjust selectors, rewrite file, re-test
8. **Update status.csv**: append/update the domain row with status "gold", author, and RSS URL
9. **Commit**: stage `R/deliver_{domain}.R` + `inst/status.csv`, commit, but do not push. leave for local manual review

The skill file should include:
- The exact Rscript commands to run (no interactive session required)
- The CSS selector decision heuristics (prefer `og:` meta tags for headline, `ld+json` for datetime, check `.author`, `.byline` for author, target the most specific paragraph container for text)
- Instructions to use `html_search()` for fallback chains rather than a single selector
- The PR template body (list of fields that passed/failed testing)

---

## What NOT to pursue (and why)

**btw package**: btw builds context for prompts but doesn't automate a workflow. It would help populate a prompt but doesn't replace the skill file.

**mcptools MCP server**: exposing `pb_collect`, `pb_find_rss`, `test_parser` as MCP tools would allow any MCP-compatible LLM to use them. This is a good *stretch goal* but adds R infrastructure complexity upfront. Recommend deferring until the Claude Code skill proves the workflow works.

**Simple prompt template**: a plain `.txt` prompt works once but doesn't integrate with the repo, can't self-test, and has no feedback loop. The Claude Code skill is strictly better.

---

## Files to create / modify

| File | Action |
|------|--------|
| `vignettes/For_Developers.Rmd` | Rewrite with current workflow |
| `R/utils_dev.R` | Add `pb_html_context()` function |
| `man/pb_html_context.Rd` | Auto-generated via `devtools::document()` |
| `.claude/commands/new-parser.md` | New Claude Code custom command |

---

## Verification

1. **Vignette**: `devtools::build_vignettes()` builds without error; content accurately describes the `use_new_parser()` flow
2. **`pb_html_context()`**: call it on a known article from `pb_collect()`, confirm the output contains the meta tags and class names actually present in that site's HTML
3. **Skill**: run `/new-parser https://www.denverpost.com/some-article/` in this repo; confirm it produces a working `R/deliver_denverpost_com.R` that passes `test_parser()` with <5% failure on all four fields

---

