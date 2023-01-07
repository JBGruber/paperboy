if (!file.exists("tests/local-files/bench_data.rds")) {
  library(mediacloud)
  bench_data <- search_stories(title = "*",
                               media_id = c(1, 2, 4),
                               after_date = "2022-10-01",
                               n = 1000L)
  while (nrow(bench_data) < 15000) {
    temp <- search_stories(title = "*",
                           media_id = c(1, 2, 4),
                           after_date = "2022-10-01",
                           n = 1000L,
                           last_processed_stories_id = max(bench_data$processed_stories_id))
    bench_data <- rbind(bench_data, temp)
    message("Date:", max(bench_data$publish_date))
  }
  saveRDS(bench_data, "tests/local-files/bench_data.rds")
}

library(tidyverse)
library(paperboy)
if (!file.exists("tests/local-files/bench_data_collected.rds")) {
  bench_data_collected <- readRDS("tests/local-files/bench_data.rds") |>
    pull(url) |>
    pb_collect(ignore_fails = TRUE)

  saveRDS(bench_data_collected, "tests/local-files/bench_data_collected.rds")
}

bench_data_collected <- readRDS("tests/local-files/bench_data_collected.rds")
nrow(bench_data_collected)

bench_data_collected <- bench_data_collected

res <- bench::mark(
  pb_deliver(x = bench_data_collected),
  iterations = 10
)

res$expression <- paste0("pb_deliver:", packageVersion("paperboy"))
res$comment <- ""

if (file.exists("tests/local-files/pb_deliver_bench.rds")) {
  res_all <- readRDS("tests/local-files/pb_deliver_bench.rds") |>
    bind_rows(res)
} else {
  res_all <- res
}

saveRDS(res_all, "tests/local-files/pb_deliver_bench.rds")

summary(res_all)
summary(res_all, relative = TRUE)
