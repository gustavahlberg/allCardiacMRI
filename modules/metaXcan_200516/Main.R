#
# MetXcan
# date: 191202
#
# ---------------------------------------------------------
#
# Clear
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")
DATA=paste(DIR,"data/",sep="/")


# ---------------------------------------------------------
#
# load libraries
#

library(rethinking)
library(rafalib)
library(xlsx)

# ---------------------------------------------------------
#
# make volcano plot from MetaXcan results
# 


source("volcanoPlots.R")


# ---------------------------------------------------------
#
# print results
# 

source("printResults.R")

#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
