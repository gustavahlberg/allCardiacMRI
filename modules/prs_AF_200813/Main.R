#
# Module for making AF prs
# 
# 1) select snps & make snp matrix
# 2) build models
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
library(tidyverse)


# ----------------------------------
#
# 1) select snps & make snp matrix
#


# source("bin/makeGenotypeMatrix.R")


# ----------------------------------
#
# 1b) make snp matrix, run via qsub
#


# source("makeGenoMatPbs.R")


# ----------------------------------
#
# 2) make pheno df
#

#source("bin/makePhenoDf.R")


# ----------------------------------
#
# 3) C+T
#

#source("bin/sct.R")
#source("bin/sctBtStrp.R")
source("bin/sctStacked.R")


# ----------------------------------
#
# 4) ld pred 2
#

#source("bin/makeGenotypeMatrix_ldpred2.R")
#source("bin/makeGenotypeMatrix_ldpred2.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
