EC2 Tools for Spark
================

Installation
------------

``` r
devtools::install_github("rstudio/sparkec2", auth_token = "56aef3d82d3ef05755e40a4f6bdaab6fbed8a1f1")
```

Usage
-----

To start a new 1-master 1-slave Spark cluster in EC2 run the following code:

``` r
library(sparkec2)
ci <- spark_ec2_cluster(access_key_id = "AAAAAAAAAAAAAAAAAAAA",
                        secret_access_key = "1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1",
                        pem_file = "spark.pem")

spark_ec2_deploy(ci)

spark_ec2_web(ci)
spark_ec2_rstudio(ci)

spark_ec2_stop(ci)
spark_ec2_destroy(ci)
```

The `access_key_id`, `secret_access_key` and `pem_file` need to be retrieved from the AWS console.

For additional configuration and examples read: [Using Spark in EC2](docs/ec2.md)
