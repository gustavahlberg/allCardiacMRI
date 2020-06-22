#
#
# Baseline 
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


source("bin/load.R")



# ---------------------------------------------
#
# Load data
#


source("bin/loadData.R")


# ---------------------------------------------
#
# def phenotypes
#

source("bin/defPhenos.R")


# ---------------------------------------------
#
# Baseline tab
#


source("bin/baselineTab.R")



# ---------------------------------------------
#
# Flowchart
#


source("")



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
