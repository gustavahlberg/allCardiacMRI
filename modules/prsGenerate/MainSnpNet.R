#
#
# Module for defining list of etnhically matched and
# unrelated samples
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


# install 
## library(devtools)
## install_github("junyangq/glmnetPlus")
## install_github("chrchang/plink-ng", subdir="/2.0/cindex")
## install_github("chrchang/plink-ng", subdir="/2.0/pgenlibr")
## install_github("junyangq/snpnet")
library(snpnet)
source("bin/configs.R")


# ---------------------------------------------
#
# test run
#

source("bin/simple.exampel.R")
