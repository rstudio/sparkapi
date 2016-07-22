#!/usr/bin/env Rscript

spark_home <- file.path(rappdirs::app_dir("spark", "rstudio")$cache(), "spark-1.6.1-bin-hadoop2.6")

spark_compile("sparkapi", spark_home = spark_home)
spark_compile("sparkapi", spark_home = spark_home)
