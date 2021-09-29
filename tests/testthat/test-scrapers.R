scrapers <- paste0(
  "paperboy:::pb_deliver_paper.",
  gsub(".", "_", pb_available(), fixed = TRUE)
)

for (scrp in scrapers) {
  expect_error(
    do.call(eval(parse(text = scrp)), list(x = "")),
    "Wrong object passed to internal deliver function: character"
  )
}

# example
# test_that("Test infrascture", {
#   expect_error(
#     paperboy:::pb_deliver_paper.nypost_com(""),
#     "Wrong object passed to internal deliver function: character"
#   )
# })
