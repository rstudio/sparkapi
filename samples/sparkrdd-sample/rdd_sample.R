library(sparkapi)

sparkHome <- "/Users/javierluraschi/Library/Caches/spark/spark-1.6.2-bin-hadoop2.6/"

sc <- start_shell(master = "local", spark_home = sparkHome)

rdd <- spark_parallelize(sc, 1:10, 2L)
newrdd <- spark_lapply(rdd, function(x) x + 1000)
spark_collect(newrdd)

stop_shell(sc)