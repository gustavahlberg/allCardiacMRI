#
# Make h2 and genetic correlation 
# figure 
#
# ------------------------------
#
# configs
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")
DATA=paste(DIR,"data/",sep="/")

cor.test.plus <- function(x) {
  list(x, 
       Standard.Error = unname(sqrt((1 - x$estimate^2)/x$parameter)))
}



# ------------------------------
#
# load data
#


df = read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                stringsAsFactors = F,
                header = T)

source("loadh2.R")



# ------------------------------
#
# pheno correlations
#


source("phenoCorr.R")


# ----------------------------------
#
# heatmap
#


source("heatmap.R")
source("corrPlot.R")

# ----------------------------------
#
# Print tables
#

source("printTables.R")


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################

