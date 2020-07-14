#
# Annontate finemapped variants
#
# -------------------------------
#
# configs
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

library(xlsx)

# -------------------------------
#
# loadData
#

source("loadData.R")


# -------------------------------
#
# make vcf
#


source("makeVcf.R")


# -------------------------------
#
# summary results
#


source("summaryResults.R")


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################


