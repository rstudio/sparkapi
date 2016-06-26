
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
spark_dependency <- function(jars, packages) {
  structure(class = "spark_dependency", list(
    jars = jars,
    packages = packages
  ))
}

#' Get the spark dependencies for extension packages
#'
#' Call the \code{spark_dependencies} function of the specified
#' package to extract it's dependencies.
#'
#' @param extension Name of extension package
#' @param extensions Names of extension packages.
#'
#' @return List of objects of type \code{spark_dependency}.
#'
#' @keywords internal
#' @rdname spark_dependencies
#'
#' @export
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


#' @name spark_dependencies
#' @export
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


