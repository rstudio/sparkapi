# Imported from:
#    https://github.com/apache/spark/blob/v1.6.2/R/pkg/R/context.R
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

# context.R: SparkContext driven functions

#' Create an RDD from a homogeneous list or vector.
#'
#' This function creates an RDD from a local homogeneous list in R. The elements
#' in the list are split into \code{numSlices} slices and distributed to nodes
#' in the cluster.
#'
#' @export
#'
#' @param sc SparkContext to use
#' @param coll collection to parallelize
#' @param numSlices number of partitions to create in the RDD
#' @return an RDD created from this collection
spark_parallelize <- function(sc, coll, numSlices = 1) {
  # TODO: bound/safeguard numSlices
  # TODO: unit tests for if the split works for all primitives
  # TODO: support matrix, data frame, etc
  # nolint start
  # suppress lintr warning: Place a space before left parenthesis, except in a function call.
  if ((!is.list(coll) && !is.vector(coll)) || is.data.frame(coll)) {
    # nolint end
    if (is.data.frame(coll)) {
      message(paste("context.R: A data frame is parallelized by columns."))
    } else {
      if (is.matrix(coll)) {
        message(paste("context.R: A matrix is parallelized by elements."))
      } else {
        message(paste("context.R: parallelize() currently only supports lists and vectors.",
                      "Calling as.list() to coerce coll into a list."))
      }
    }
    coll <- as.list(coll)
  }
  
  if (numSlices > length(coll))
    numSlices <- length(coll)
  
  sliceLen <- ceiling(length(coll) / numSlices)
  slices <- split(coll, rep(1: (numSlices + 1), each = sliceLen)[1:length(coll)])
  
  # Serialize each slice: obtain a list of raws, or a list of lists (slices) of
  # 2-tuples of raws
  serializedSlices <- lapply(slices, serialize, connection = NULL)
  
  jrdd <- invoke_static(sc,
                        "org.apache.spark.api.r.RRDD",
                        "createRDDFromArray",
                        java_context(sc),
                        serializedSlices)
  
  spark_rdd_init(jrdd, "byte")
}

