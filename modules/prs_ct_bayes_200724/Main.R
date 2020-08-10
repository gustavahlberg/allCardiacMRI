#
# Module for making c+t prs
# 
# 1) load samples
# 2) select snps
# 2) load genotype matrix
# 3) build models
# 4) 
# 5) save model
#
# ----------------------------------
#
# configs
#

library(bigreadr)
library(bigsnpr)
library(data.table)
library(caret)

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

args = commandArgs(trailingOnly=TRUE)
pheno = args[1]
print(paste("running",pheno, "..."))



# ----------------------------------
#
# 1) load samples
#


#source("bin/loadSamplLists.R")


# ----------------------------------
#
# 2) select snps & make snp matrix
#

#source("bin/selectSnps.R")


# ----------------------------------
#
# 3) C + T 
#

# source("bin/sct.R")


# ----------------------------------
#
# 4) C+T  + bayes regression
#

#source("bin/bayesRR_prs.R")
#source("bin/bayes_prs.R")


# ----------------------------------
#
# 5) predict bayes
#


#source("bin/bayesRR_predict.R")


# ----------------------------------
#
# 6) predict bayes
#


source('bin/sctBootstrap.R')

#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################
