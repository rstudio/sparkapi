

#' Register a package that implements a sparkapi extension
#'
#' Registering an extension package will result in the package being
#' automatically scanned for spark dependencies when a connection
#' to Spark is initiated (e.g. via \code{start_shell}).
#'
#' @param package Name of package to register
#'
#' @note Extensions are typically registered when packages are
#'   loaded onto the search path (i.e. in the \code{.onLoad}
#'   function).
#'
#' @export
register_extension <- function(package) {
  .globals$extension_packages <- c(.globals$extension_packages, package)
}

#' Enumerate all registered extension packages

#' @rdname register_extension
#' @export
registered_extensions <- function() {
  .globals$extension_packages
}


#' Define a Spark dependency
#'
#' Define a Spark dependency consisting of a set of custom JARs and Spark packages.
#'
#' @param jars Character vector of full paths to JAR files
#' @param packages Character vector of Spark packages names
#'
#' @return An object of type `spark_dependency`
#'
#' @export
spark_dependency <- function(jars = NULL, packages = NULL) {
  structure(class = "spark_dependency", list(
    jars = jars,
    packages = packages
  ))
}

spark_dependencies_from_extension <- function(extension) {

  # attempt to find the function
  spark_dependencies <- tryCatch({
      get("spark_dependencies", asNamespace(extension), inherits = FALSE)
    },
    error = function(e) {
      stop("spark_dependencies function not found within ",
           "extension package ", extension, call. = FALSE)
    }
  )

  # call the function
  dependency <- spark_dependencies()

  # if it's just a single dependency then wrap it in a list
  if (inherits(dependency, "spark_dependency"))
    dependency <- list(dependency)

  # return it
  dependency
}


spark_dependencies_from_extensions <- function(extensions) {

  jars <- character()
  packages <- character()

  lapply(extensions, function(extension) {
    dependencies <- spark_dependencies_from_extension(extension)
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

spark_dependencies_from_extension <- function(extension) {

  # attempt to find the function
  spark_dependencies <- tryCatch({
    get("spark_dependencies", asNamespace(extension), inherits = FALSE)
  },
  error = function(e) {
    stop("spark_dependencies function not found within ",
         "extension package ", extension, call. = FALSE)
  }
  )

  # call the function
  dependency <- spark_dependencies()

  # if it's just a single dependency then wrap it in a list
  if (inherits(dependency, "spark_dependency"))
    dependency <- list(dependency)

  # return it
  dependency
}

