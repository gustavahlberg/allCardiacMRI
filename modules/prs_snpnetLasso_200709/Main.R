#
# Module for making prs with
# snpnet lasso
# 
# 1) select unrelated samples sets training/test validation,
# 2) QC snpset
# 3) run fit_snpnet
# 4) predict on validation
# 5) save model
#
# ----------------------------------
#
# configs
#

library(data.table)

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


# ----------------------------------
#
# 1) select unrelated sample sets training/validation test
#


source("bin/makeSampleSets.R")


# ----------------------------------
#
# 2) QC snpset 
#





