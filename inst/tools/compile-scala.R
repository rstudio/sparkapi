#!/usr/bin/env Rscript
options(repos = c(CRAN = "https://cran.rstudio.com"))

if (!requireNamespace("rprojroot", quietly = TRUE))
  install.packages("rprojroot")
library(rprojroot)
root <- rprojroot::find_package_root_file()

if (!requireNamespace("digest", quietly = TRUE))
  install.packages("digest")
library(digest)

sparkapi_path <- file.path(root, "inst/java/sparkapi.jar")
sparkapi_scala <- lapply(
  Filter(
    function(e) grepl(".*\\.scala$", e),
    list.files(file.path(root, "inst", "scala"))
  ),
  function(e) file.path(root, "inst", "scala", e)
)
sparkapi_scala_digest <- file.path(root, "inst/scala/sparkapi.scala.md5")

sparkapi_scala_contents <- paste(lapply(sparkapi_scala, function(e) readLines(e)))
sparkapi_scala_contents_path <- tempfile()
sparkapi_scala_contents_file <- file(sparkapi_scala_contents_path, "w")
writeLines(sparkapi_scala_contents, sparkapi_scala_contents_file)
close(sparkapi_scala_contents_file)

# Bail if 'sparkapi.scala' hasn't changed
md5 <- tools::md5sum(sparkapi_scala_contents_path)
if (file.exists(sparkapi_scala_digest) && file.exists(sparkapi_path)) {
  contents <- readChar(sparkapi_scala_digest, file.info(sparkapi_scala_digest)$size, TRUE)
  if (identical(contents, md5[[sparkapi_scala_contents_path]])) {
    stop()
  }
}

message("** building 'sparkapi.jar' ...")

cat(md5, file = sparkapi_scala_digest)

execute <- function(...) {
  cmd <- paste(...)
  message("*** ", cmd)
  system(cmd)
}

if (!nzchar(Sys.which("scalac")))
  stop("failed to discover 'scalac' on the PATH")

if (!nzchar(Sys.which("jar")))
  stop("failed to discover 'jar' on the PATH")

# Work in temporary directory (as temporary class files
# will be generated within there)
dir <- file.path(tempdir(), "sparkapi-scala-compile")
if (!file.exists(dir))
  if (!dir.create(dir))
    stop("Failed to create '", dir, "'")
owd <- setwd(dir)

spark_version <- "1.6.1"
hadoop_version <- "2.6"

# get installation path
sparkVersionDir <- file.path(
  rappdirs::app_dir("spark", "rstudio")$cache(),
  paste0(
    "spark-",
    spark_version,
    "-bin-hadoop",
    hadoop_version
  )
)

if (!dir.exists(sparkVersionDir)) {
  stop("Spark home not found under: ", sparkVersionDir)
}

# list jars in the installation folder
candidates <- c("jars", "lib")
jars <- NULL
for (candidate in candidates) {
  jars <- list.files(
    file.path(sparkVersionDir, candidate),
    full.names = TRUE,
    pattern = "jar$"
  )

  if (length(jars))
    break
}

if (!length(jars))
  stop("failed to discover Spark jars")

# construct classpath
CLASSPATH <- paste(jars, collapse = .Platform$path.sep)

# ensure 'inst/java' exists
inst_java_path <- file.path(root, "inst/java")
if (!file.exists(inst_java_path))
  if (!dir.create(inst_java_path, recursive = TRUE))
    stop("failed to create directory '", inst_java_path, "'")

# call 'scalac' compiler
classpath <- Sys.getenv("CLASSPATH")

# set CLASSPATH environment variable rather than passing
# in on command line (mostly aesthetic)
Sys.setenv(CLASSPATH = CLASSPATH)
execute("scalac", paste(shQuote(sparkapi_scala), collapse = " "))
Sys.setenv(CLASSPATH = classpath)

# call 'jar' to create our jar
class_files <- file.path("sparkapi", list.files("sparkapi", pattern = "class$"))
execute("jar cf", sparkapi_path, paste(shQuote(class_files), collapse = " "))

# double-check existence of 'sparkapi.jar'
if (file.exists(sparkapi_path)) {
  message("*** ", basename(sparkapi_path), " successfully created.")
} else {
  stop("*** failed to create sparkapi.jar")
}

setwd(owd)
