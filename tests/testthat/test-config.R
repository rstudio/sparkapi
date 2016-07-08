library(testthat)

context("Config")

mock_spark_config <- function(master, config = list()) {
  list(
    master = master,
    config = config
  )
}

test_that("supported spark_versions can be downloaded", {
  sc <- mock_spark_config(master = "local", config = list(
    "spark.sql.value" = "ok",
    "spark.value" = "not ok"
  ))

  params <- connection_config(sc, "spark.", c("spark.sql."))

  expect_true(length(params) == 1)
})
