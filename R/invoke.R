
#' Execute a method on a remote Java object
#'
#' @param connection Connection to execute on.
#' @param jobj Java object to execute method on.
#' @param class Class to execute static method on.
#' @param method Name of method to execute.
#' @param ... Unused (future expansion)
#'
#' @export
invoke <- function (jobj, method, ...)
{
  invoke_method(spark_connection(jobj),
                FALSE,
                jobj$id,
                method,
                ...)
}


#' @name invoke
#' @export
invoke_static <- function (connection, class, method, ...)
{
  invoke_method(spark_connection(connection),
                TRUE,
                class,
                method,
                ...)
}


#' @name invoke
#' @export
invoke_new <- function(connection, class, ...)
{
  invoke_method(spark_connection(connection),
                TRUE,
                class,
                "<init>",
                ...)
}


#' Stop the RBackend that services RPC request
#'
#' @param connection Connection to stop the backend for
#'
#' @keywords internal
#'
#' @export
stop_backend <- function(connection) {
  invoke_method(spark_connection(connection),
                FALSE,
                "SparkRHandler",
                "stopBackend")
}


invoke_method <- function(connection, isStatic, objName, methodName, ...)
{
  if (is.null(connection)) {
    stop("The connection is no longer valid.")
  }

  rc <- rawConnection(raw(), "r+")
  writeBoolean(rc, isStatic)
  writeString(rc, objName)
  writeString(rc, methodName)

  args <- list(...)
  writeInt(rc, length(args))
  writeArgs(rc, args)
  bytes <- rawConnectionValue(rc)
  close(rc)

  rc <- rawConnection(raw(0), "r+")
  writeInt(rc, length(bytes))
  writeBin(bytes, rc)
  con <- rawConnectionValue(rc)
  close(rc)

  backend <- connection$backend
  writeBin(con, backend)

  returnStatus <- readInt(backend)
  if (length(returnStatus) == 0)
    stop("No status is returned. Spark R backend might have failed.")
  if (returnStatus != 0) {
    # get error message from backend and report to R
    msg <- readString(backend)
    if (nzchar(msg))
      stop(msg, call. = FALSE)
    else {
      # call unknown error handler if we have one
      msg <- "<unknown error>"
      handler <- unknown_error_handler()
      if (!is.null(handler))
        msg <- handler(connection)
      stop(msg, call. = FALSE)
    }
  }

  object <- readObject(backend)
  attach_connection(object, connection)
}

attach_connection <- function(jobj, connection) {

  if (inherits(jobj, "spark_jobj")) {
    jobj$connection <- connection
  }
  else if (is.list(jobj) || inherits(jobj, "struct")) {
    jobj <- lapply(jobj, function(e) {
      attach_connection(e, connection)
    })
  }
  else if (is.environment(jobj)) {
    jobj <- eapply(jobj, function(e) {
      attach_connection(e, connection)
    })
  }

  jobj
}

# A scope where we can put mutable global state
.globals <- new.env(parent = emptyenv())

#' Get or set the current unknown error handler
#'
#' Get or set the current unknown error handler. This function
#' is called when the backend fails to report an error message.
#'
#' @param handler A function which accepts a \code{spark_connection}
#'   and returns a single-element character vector. Pass \code{NULL}
#'   to read the current value (if any).
#'
#' @return The current handler if \code{NULL} is passed and the
#'   previously installed handler when a new handler is passed.
#'
#' @keywords internal
#'
#' @export
unknown_error_handler <- function(handler = NULL) {
  previous_handler <- .globals[["unknown_error_handler"]]
  if (!is.null(handler))
    .globals[["unknown_error_handler"]] <- handler
  previous_handler
}

