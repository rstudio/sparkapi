# Imported from:
#    https://github.com/apache/spark/blob/v1.6.2/R/pkg/R/RDD.R
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#' @rdname RDD
#' @noRd
#' @param jrdd Java object reference to the backing JavaRDD
#' @param serializedMode Use "byte" if the RDD stores data serialized in R, "string" if the RDD
#' stores strings, and "row" if the RDD stores the rows of a DataFrame
#' @param isCached TRUE if the RDD is cached
#' @param isCheckpointed TRUE if the RDD has been checkpointed
spark_rdd_init <- function(jrdd, serializedMode = "byte", isCached = FALSE,
                           isCheckpointed = FALSE) {
  # Check that RDD constructor is using the correct version of serializedMode
  stopifnot(class(serializedMode) == "character")
  stopifnot(serializedMode %in% c("byte", "string", "row"))
  # RDD has three serialization types:
  # byte: The RDD stores data serialized in R.
  # string: The RDD stores data as strings.
  # row: The RDD stores the serialized rows of a DataFrame.
  
  # We use an environment to store mutable states inside an RDD object.
  # Note that R's call-by-value semantics makes modifying slots inside an
  # object (passed as an argument into a function, such as cache()) difficult:
  # i.e. one needs to make a copy of the RDD object and sets the new slot value
  # there.
  
  # The slots are inheritable from superclass. Here, both `env' and `jrdd' are
  # inherited from RDD, but only the former is used.
  rdd <- list()
  rdd$env <- new.env()
  rdd$env$isCached <- isCached
  rdd$env$isCheckpointed <- isCheckpointed
  rdd$env$serializedMode <- serializedMode
  
  rdd$jrdd <- jrdd
  
  structure(class = c("spark_rdd"), rdd)
}

spark_rdd_pipelined_init <- function(prev = NULL, func, jrdd_val = NULL) {
  rdd <- list()
  rdd$env <- new.env()
  rdd$env$isCached <- FALSE
  rdd$env$isCheckpointed <- FALSE
  rdd$env$jrdd_val <- jrdd_val
  if (!is.null(jrdd_val)) {
    # This tracks the serialization mode for jrdd_val
    rdd$env$serializedMode <- prev$env$serializedMode
  }
  
  rdd$prev <- prev
  
  isPipelinable <- function(rdd) {
    e <- rdd$env
    # nolint start
    !(e$isCached || e$isCheckpointed)
    # nolint end
  }
  
  if (!("spark_rdd_pipelined" %in% class(prev)) || !isPipelinable(prev)) {
    # This transformation is the first in its stage:
    rdd$func <- cleanClosure(func)
    rdd$prev_jrdd <- getJRDD(prev)
    rdd$env$prev_serializedMode <- prev$env$serializedMode
    # NOTE: We use prev_serializedMode to track the serialization mode of prev_JRDD
    # prev_serializedMode is used during the delayed computation of JRDD in getJRDD
  } else {
    pipelinedFunc <- function(partIndex, part) {
      f <- prev$func
      func(partIndex, f(partIndex, part))
    }
    rdd$func <- cleanClosure(pipelinedFunc)
    rdd$prev_jrdd <- prev$prev_jrdd # maintain the pipeline
    # Get the serialization mode of the parent RDD
    rdd$env$prev_serializedMode <- prev$env$prev_serializedMode
  }
  
  structure(class = c("spark_rdd_pipelined"), rdd)
}

# Return the serialization mode for an RDD.
getSerializedMode <- function(rdd) {
  UseMethod("getSerializedMode")
}

# For normal RDDs we can directly read the serializedMode
getSerializedMode.spark_rdd <- function(rdd) {
  rdd$env$serializedMode
}

# For pipelined RDDs if jrdd_val is set then serializedMode should exist
# if not we return the defaultSerialization mode of "byte" as we don't know the serialization
# mode at this point in time.
getSerializedMode.spark_rdd_pipelined <- function(rdd) {
  if (!is.null(rdd$env$jrdd_val)) {
    return(rdd$env$serializedMode)
  } else {
    return("byte")
  }
}

# The jrdd accessor function.
getJRDD <- function(rdd) {
  UseMethod("getJRDD")
}

getJRDD.spark_rdd <- function(rdd) {
  rdd$jrdd
}

getJRDD.spark_rdd_pipelined <- function(rdd, serializedMode = "byte") {
  if (!is.null(rdd$env$jrdd_val)) {
    return(rdd$env$jrdd_val)
  }
  sc <- spark_connection(rdd$prev_jrdd)
  packageNamesArr <- serialize(sc$packages,
                               connection = NULL)
  
  broadcastArr <- list()
  
  serializedFuncArr <- serialize(rdd$func, connection = NULL)
  
  prev_jrdd <- rdd$prev_jrdd
  
  if (serializedMode == "string") {
    rddRef <- invoke_new(sc,
                         "org.apache.spark.api.r.StringRRDD",
                         invoke(prev_jrdd, "rdd"),
                         serializedFuncArr,
                         rdd$env$prev_serializedMode,
                         packageNamesArr,
                         broadcastArr,
                         invoke(prev_jrdd, "classTag"))
  } else {
    rddRef <- invoke_new(sc,
                         "org.apache.spark.api.r.RRDD",
                         invoke(prev_jrdd, "rdd"),
                         serializedFuncArr,
                         rdd$env$prev_serializedMode,
                         serializedMode,
                         packageNamesArr,
                         broadcastArr,
                         invoke(prev_jrdd, "classTag"))
  }
  # Save the serialization flag after we create a RRDD
  rdd$env$serializedMode <- serializedMode
  rdd$env$jrdd_val <- invoke(rddRef, "asJavaRDD")
  rdd$env$jrdd_val
}

#' Collect elements of an RDD
#'
#' @description
#' \code{collect} returns a list that contains all of the elements in this RDD.
#'
#' @export
#'
#' @param x The RDD to collect
#' @param ... Other optional arguments to collect
#' @param flatten FALSE if the list should not flattened
#' @return a list containing elements in the RDD
spark_collect <- function(x, flatten = TRUE) {
  # Assumes a pairwise RDD is backed by a JavaPairRDD.
  collected <- invoke(getJRDD(x), "collect")
  convertJListToRList(collected, flatten,
                      serializedMode = getSerializedMode(x))
}

#' Apply a function to all elements
#'
#' This function creates a new RDD by applying the given transformation to all
#' elements of the given RDD
#'
#' @export
#'
#' @param X The RDD to apply the transformation.
#' @param FUN the transformation to apply on each element
#' @return a new RDD created by the transformation.
spark_lapply <- function(X, FUN) {
  UseMethod("spark_lapply")
}

#' @export
spark_lapply.spark_rdd <- function(X, FUN) {
  func <- function(partIndex, part) {
    lapply(part, FUN)
  }
  spark_lapply_partitions_with_index(X, func)
}

spark_lapply_partitions_with_index <- function(X, FUN) {
  spark_rdd_pipelined_init(X, FUN)
}
