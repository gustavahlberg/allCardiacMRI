#
#
# Module for plotting and tabelling 
# mtcojo and gsmr results
#
# ---------------------------------------------
#
# Configs, set relative path and source enviroment
#

library(rafalib)
library(rethinking)
library(xlsx)

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")




# ---------------------------------------------
#
# mtcojo
#


source("bin/mtCojoPlots.R")


# ---------------------------------------------
#
# gsmr
#


source("bin/gsmrPlots.R")
source("bin/gsmrTables.R")



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################


