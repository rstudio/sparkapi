


#' Get the SparkContext associated with a connection
#'
#' Get the SparkContext \code{spark_jobj} associated with a
#' \code{spark_connection}
#'
#' @param sc Connection to get SparkContext from
#'
#' @return Reference to SparkContext
#' @export
spark_context <- function(sc) {
  spark_connection(sc)$spark_context
}


#' Get the spark_connection associated with an object
#'
#' S3 method to get the spark_connection associated with objects of
#' various types.
#'
#' @param x Object to extract connection from
#' @param ... Reserved for future use
#' @return A \code{spark_connection} object that can be passed to
#'   \code{\link{invoke_new}} and \code{\link{invoke_static}}.
#'
#' @export
spark_connection <- function(x, ...) {
  UseMethod("spark_connection")
}

#' @export
spark_connection.default <- function(x, ...) {
  stop("Unable to retreive a spark_connection from object of class ",
       paste(class(x), collapse = " "), call. = FALSE)
}

#' @export
spark_connection.spark_connection <- function(x, ...) {
  x
}

#' @export
spark_connection.spark_jobj <- function(x, ...) {
  x$connection
}

#' Check whether the connection is open
#'
#' @param sc \code{spark_connection}
#'
#' @keywords internal
#'
#' @export
connection_is_open <- function(sc) {
  UseMethod("connection_is_open")
}

#' Read configuration values
#'
#' @param config List with configuration values
#' @param master Master node
#' @param prefix Optional prefix to read parameters for
#'   (e.g. \code{spark.context.}, \code{spark.sql.}, etc.)
#'
#' @return Named list of config parameters (note that if a prefix was
#'  specified then the names will not include the prefix)
#'
#' @export
read_config <- function(config, master, prefix = NULL) {

  isLocal <- spark_master_is_local(master)
  configNames <- Filter(function(e) {
    found <- is.null(prefix) ||
      (substring(e, 1, nchar(prefix)) == prefix)

    if (grepl("\\.local$", e) && !isLocal)
      found <- FALSE

    if (grepl("\\.remote$", e) && isLocal)
      found <- FALSE

    found
  }, names(config))

  paramsNames <- lapply(configNames, function(configName) {
    paramName <- substr(configName, nchar(prefix) + 1, nchar(configName))
    paramName <- sub("(\\.local$)|(\\.remote$)", "", paramName, perl = TRUE)

    paramName
  })

  params <- lapply(configNames, function(configName) {
    config[[configName]]
  })

  names(params) <- paramsNames
  params
}

spark_master_is_local <- function(master) {
  grepl("^local(\\[[0-9\\*]*\\])?$", master, perl = TRUE)
}


#' Retrieves entries from the Spark log
#'
#' @param sc \code{spark_connection}
#' @param n Max number of log entries to retrieve (pass NULL to retrieve
#'   all lines of the log)
#'
#' @return Character vector with last \code{n} lines of the Spark log
#'   or for \code{spark_log_file} the full path to the log file.
#'
#' @export
spark_log <- function(sc, n = 100) {
  UseMethod("spark_log")
}

#' @export
spark_log.default <- function(...) {
  stop("Invalid class passed to spark_log")
}

#' @export
print.spark_log <- function(x, ...) {
  cat(x, sep = "\n")
  cat("\n")
}

#' Open the Spark web interface
#'
#' @inheritParams spark_log
#'
#' @export
spark_web <- function(sc) {
  UseMethod("spark_web")
}

#' @export
spark_web.default <- function(...) {
  stop("Invalid class passed to spark_web")
}


#' @export
print.spark_web_url <- function(x, ...) {
  utils::browseURL(x)
}











