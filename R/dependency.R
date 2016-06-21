
#' Define a Spark API dependency
#'
#' Define a Spark API dependency consisting of a set of custom JARs and Spark packages.
#'
#' @param jars Character vector of full paths to JAR files
#' @param packages Character vector of Spark packages names
#'
#' @return An object of type `sparkapi_dependency`
#'
#' @export
sparkapi_dependency <- function(jars, packages) {
  structure(class = "sparkapi_dependency", list(
    jars = jars,
    packages = packages
  ))
}

#' Get the sparkapi dependencies for extension packages
#'
#' Call the \code{sparkapi_dependencies} function of the specified
#' package to extract it's dependencies.
#'
#' @param config R list containing configuration data
#' @param extension Name of extension package
#' @param extensions Names of extension packages.
#'
#' @return List of objects of type \code{spark_dependency}.
#'
#' @keywords internal
#' @rdname sparkapi_dependencies
#'
#' @export
sparkapi_dependencies_from_extension <- function(config, extension) {

  # attempt to find the function
  sparkapi_dependencies <- tryCatch({
      get("sparkapi_dependencies", asNamespace(extension), inherits = FALSE)
    },
    error = function(e) {
      stop("sparkapi_dependencies function not found within ",
           "extension package ", extension, call. = FALSE)
    }
  )

  # call the function
  dependency <- sparkapi_dependencies(config)

  # if it's just a single dependency then wrap it in a list
  if (inherits(dependency, "sparkapi_dependency"))
    dependency <- list(dependency)

  # return it
  dependency
}


#' @name sparkapi_dependencies
#' @export
sparkapi_dependencies_from_extensions <- function(config, extensions) {

  jars <- character()
  packages <- character()

  lapply(extensions, function(extension) {
    dependencies <- sparkapi_dependencies_from_extension(config, extension)
    lapply(dependencies, function(dependency) {
      jars <<- c(jars, dependency$jars)
      packages <<- c(packages, dependency$packages)
    })
  })

  list(
    jars = jars,
    packages = packages
  )
}


