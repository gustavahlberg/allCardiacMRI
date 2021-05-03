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

# ---------------------------------------------
#
# Load data
#



source("loadData.R")




# ---------------------------------------------
#
# Calc. PVE
#


source("calcPve.R")




# ---------------------------------------------
#
# make table
#


source("makeTable.R")



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
