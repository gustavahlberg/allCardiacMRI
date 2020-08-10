#
# Module for making prs with
# snpnet lasso
# 
# 1) select snps
# 2) load genotype matrix
# 3) load genotype matrix
# 4) run big_spLinReg on test K=10
# 5) save model
#
# ----------------------------------
#
# configs
#

library(bigsnpr)
library(data.table)
library(caret)

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")



# ----------------------------------
#
# 1) select snps
#

source("bin/selectSnps.R")


# ----------------------------------
#
# 2) samples
#

source("bin/loadSampleLists.R")



# ----------------------------------
#
# 3) load genotype matrix
#

source("bin/makeBigSnprMatrix.R")


# ----------------------------------
#
# 4) run big_spLinReg on test K=10
#

# save to here
save(qcTab, phenoTab,ind.indiv, ind.test, ind.train, file = "data/phenotypeData.rda")

source("bin/run_spLinReg.R")
system("msub -t 1-7 run_spLinReg.pbs")


# ----------------------------------
#
# 5) predict
#

source("bin/predictModels.R")


# ----------------------------------
#
# 5) save model
#
