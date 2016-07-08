library(testthat)

context("Config")

mock_spark_config <- function(master, config = list()) {
  list(
    master = master,
    config = config
  )
}

test_that("connection_config can retrieve correct prefixes", {
  sc <- mock_spark_config(master = "local", config = list(
    "spark.session.value1" = "1",
    "spark.session.value2" = "2"
  ))

  params <- connection_config(sc, "spark.session.")

  expect_true(length(params) == 2)
})

test_that("connection_config can filter out prefixes", {
  sc <- mock_spark_config(master = "local", config = list(
    "spark.sql.value" = "ok",
    "spark.value" = "not ok"
  ))

  params <- connection_config(sc, "spark.", c("spark.sql.",
                                              "spark.session."))

  expect_true(length(params) == 1)
})
