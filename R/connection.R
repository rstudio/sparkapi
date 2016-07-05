

#' Create a spark_connection object.
#'
#' Create a \code{spark_connection} based on the specified backend
#' and monitor sockets.
#'
#' @details
#' This connection can be passed to the
#' \code{\link{invoke_new}} and \code{\link{invoke_static}}
#' functions.
#'
#' @param spark_context Instance of SparkContext object
#' @param hive_context Instance of HiveContext object
#' @param backend R socket connection to backend
#' @param monitor R socket connection for monitor
#'
#' @return Object of class \code{spark_connection}.
#'
#' @seealso \code{\link{spark_connection}}
#'
#' @keywords internal
#'
#' @export
spark_connection_create <- function(spark_context,
                                    hive_context,
                                    backend,
                                    monitor) {
  structure(class = "spark_connection", list(
    spark_context = spark_context,
    hive_context = hive_context,
    backend = backend,
    monitor = monitor
  ))
}

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

#' Get the HiveContext associated with a connection
#'
#' Get the HiveContext \code{spark_jobj} associated with a
#' \code{spark_connection}
#'
#' @param sc Connection to get HiveContext from
#'
#' @return Reference to HiveContext
#' @export
hive_context <- function(sc) {
  spark_connection(sc)$hive_context
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
#' @seealso \code{\link{spark_connection_create}}
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


#' Read the shell file from the Spark R Backend
#'
#' Read the shell file and extract the backend port, monitor port,
#' and R library path.
#'
#' @param shell_file Shell file to read
#'
#' @return List with \code{backendPort}, \code{monitorPort}, and
#'   \code{rLibraryPath}
#'
#' @keywords internal
#'
#' @export
read_shell_file <- function(shell_file) {

  shellOutputFile <- file(shell_file, open = "rb")
  backendPort <- readInt(shellOutputFile)
  monitorPort <- readInt(shellOutputFile)
  rLibraryPath <- readString(shellOutputFile)
  close(shellOutputFile)

  success <- length(backendPort) > 0 && backendPort > 0 &&
    length(monitorPort) > 0 && monitorPort > 0 &&
    length(rLibraryPath) == 1

  if (!success)
    stop("Invalid values found in shell output")

  list(
    backendPort = backendPort,
    monitorPort = monitorPort,
    rLibraryPath = rLibraryPath
  )
}


spark_connection_is_open <- function(connection) {
  bothOpen <- FALSE
  if (!is.null(connection)) {
    backend <- connection$backend
    monitor <- connection$monitor

    tryCatch({
      bothOpen <- isOpen(backend) && isOpen(monitor)
    }, error = function(e) {
    })
  }

  bothOpen
}


