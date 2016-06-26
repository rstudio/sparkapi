

#' Start the Spark R Shell
#'
#' @inheritParams base::system2
#'
#' @param Extension packages to include dependencies for
#'   (see \code{\link{spark_dependency}}).
#'
#' @export
start_shell <- function(spark_home,
                        jars = NULL,
                        packages = NULL,
                        extensions = NULL,
                        environment = NULL,
                        shell_args = NULL) {

  # validate spark_home
  if (!dir.exists(spark_home))
    stop("spark_home directory '", spark_home ,"' not found")

  # determine path to spark_submit
  spark_submit <- switch(.Platform$OS.type,
    unix = "spark-submit",
    windows = "spark-submit.cmd"
  )
  spark_submit_path <- file.path(spark_home, "bin", spark_submit)

  # resolve extensions
  extensions <- spark_dependencies_from_extensions(extensions)

  # combine passed jars and packages with extensions
  jars <- unique(c(jars, extensions$jars))
  packages <- unique(c(packages, extensions$packages))

  # add jars and packages to arguments
  shell_args <- c(shell_args, "--jars", paste(jars, sep=","))
  shell_args <- c(shell_args, "--packages", paste(packages, sep=","))

  # add sparkr-shell to args
  shell_args <- c(shell_args, "sparkr-shell")

  # create temporary file for shell ports output and add it to the args
  shell_output_path <- tempfile(fileext = ".out")
  on.exit(unlink(shell_output_path))
  shell_args <- c(shell_args, shell_output_path)

  # create temp file for stdout and stderr
  output_file <- tempfile(fileext = "_spark.log")

  # start the shell
  system2(spark_submit_path,
          args = shell_args,
          stdout = output_file,
          stderr = output_file,
          env = environment,
          wait = FALSE)



  # return the output_file
  output_file
}

stop_shell <- function(sc) {

}
