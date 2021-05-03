#
#
# Calculate variance explained by sentinel SNPs
#
# The variance explained (VarExp) by each SNP was calculated using 
# the effect allele frequency (f) and beta (β) 
# from the meta-analyses using the formula VarExp = β2(1 − f)2f.
#
# PVE: 
# 2βˆ2MAF(1 − MAF)/ (2βˆ2MAF(1 − MAF) + (se(βˆ))2 2NMAF(1 − MAF))
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(data.table)
library(rhdf5)
library(lubridate)


ukbbphenoPath <- '/home/projects/cu_10039/data/UKBB/phenotypeFn/'
h5.fn <- paste(ukbbphenoPath,"ukb41714.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")[,1]



# ---------------------------------------------
#
# Load data
#


source("bin/loadData.R")




# ---------------------------------------------
#
# make instrument variables
#


source("bin/makeInstrumentVariables.R")


# ---------------------------------------------
#
# 2SLS
#



source("bin/2SLS.R")
