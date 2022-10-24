#
#
# Calculate variance explained by sentinel SNPs
#
# The variance explained (VarExp) by each SNP was calculated using 
# the effect allele frequency (f) and beta (β) 
# from the meta-analyses using the formula VarExp = β2(1 − f)2f.
#
#
# ---------------------------------------------
#
# Set relative path an source environment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(data.table)
library(rhdf5)
library(lubridate)


ukbbphenoPath <- "~/Projects/ManageUkbb/data/phenotypeFile/"
#ukbbphenoPath <- '/home/projects/cu_10039/data/UKBB/phenotypeFn/'
h5.fn <- paste(ukbbphenoPath,"ukb41714.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")[,1]


# ---------------------------------------------
#
# Load data
#

source("bin/loadData.R")


# ---------------------------------------------
#
# add phenotype
#

source("bin/addPhenotypes.R")

df$ilamin <- NA;  df$ilamax <- NA; df$laaef <- NA;
df$lapef <- NA; df$latef <- NA; 
df[trainingSet, ]$laaef <- scale(phenoTab[trainingSet, ]$laaef)
df[trainingSet, ]$lapef <- scale(phenoTab[trainingSet, ]$lapef)
df[trainingSet, ]$latef <- scale(phenoTab[trainingSet, ]$latef)
df[trainingSet, ]$ilamax <- scale(phenoTab[trainingSet, ]$ilamax)
df[trainingSet, ]$ilamin <- scale(phenoTab[trainingSet, ]$ilamin)

save(df, file = "dataFrame_210503.rda")

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



# ---------------------------------------------
#
# Variable selection for predicting LA volume&function
#


#source("bin/varSelect.R")
source("bin/varSelectGlmnet.R")


# ---------------------------------------------
#
# effect modification by AF
#

source("bin/effectModAF.R")


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

