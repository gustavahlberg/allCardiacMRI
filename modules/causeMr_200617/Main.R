#
#
# Module for cause and LCV
#
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


# devtools::install_version("mixsqp", version = "0.1-97", repos = "http://cran.us.r-project.org")
# devtools::install_version("ashr", version = "2.2-32", repos = "http://cran.us.r-project.org")
# devtools::install_github("jean997/cause@v1.0.0")
library(cause)

# ---------------------------------------------
#
# load data
#


source("loadData.R")
