#
#
# Module for colocaliztion analyses
# 
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

library(coloc)
library(GenomicFeatures)
library(data.table)
library(locuscomparer)
library(biomaRt)
library(xlsx)

# ---------------------------------------------
#
# Load data
#


source("loadData.R")


# ---------------------------------------------
#
# aadd pval to locus list
#

source("loadPvals.R")
#loci = loci.bakk
#loci.bakk = loci




for(i in 1:length(loci)) {
  locus = loci[[i]]
  start = locus$position[which.min(locus$pval)] - 2.5e5
  stop = locus$position[which.min(locus$pval)] + 2.5e5
  locus <- locus[which(locus$position > start & locus$position < stop),]
  loci[[i]] <- locus
}



# ---------------------------------------------
#
# run coloc
#


source("colocAnalyses.R")


# ---------------------------------------------
#
# make result tables
#

source("makeResultTables.R")

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################