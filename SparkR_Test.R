install.packages("SparkR")
install.packages("devtools")
library("devtools")
install.packages("memoise")
library(devtools)
install_github("amplab-extras/SparkR-pkg", subdir="pkg")
install.packages("rJava")
library("rJava")
library("SparkR",lib.loc="F:\\software\\spark-2.0.0-bin-hadoop2.7\\R\\lib\\SparkR")
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "F:\\software\\spark-2.0.0-bin-hadoop2.7")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))

or
Sys.getenv("JAVA_HOME")
install.packages('rJava','http://www.rforge.net/')
library(rJava,lib.loc="C:\\Users\\sambhav\\Documents\\R\\win-library\\3.0\\rJava")

library(rJava,lib.loc=" 'C:\\Users\\sambhav\\Documents\\R\\win-library\\3.0\\file143811fb6cad\\rJava")
sparkR.session(master = "spark://192.168.2.247:7077", sparkConfig = list(spark.driver.memory = "2g"))
install.packages("httr")
devtools::install_github("rstudio/sparklyr")
ERROR: dependencies 'config', 'rprojroot' are not available for package 'sparklyr'
* removing 'F:/NewDownloads/R/R-3.1.3/library/sparklyr'

Sys.setenv(spark.sql.warehouse.dir = "file:///F://software") 

OR


Install the library:
  
install.packages("devtools")
library(devtools,lib="F:\\software\\Rlibs")
library(httr,lib="F:\\software\\Rlibs")
install.packages("curl")
library(curl)
devtools::install_github('rstudio/sparklyr')
ERROR: dependencies 'lazyeval', 'dplyr', 'config', 'rappdirs', 'rprojroot' are not available for package 'sparklyr'

ummarise.o test.o window.o"' had status 127
ERROR: compilation failed for package 'dplyr'
* removing 'F:/software/R-3.1.2/library/dplyr'
* restoring previous 'F:/software/R-3.1.2/library/dplyr'
Load library and install spark.

library(sparklyr)
spark_install('1.6.2')