#
#
# Module for twoSample
# unrelated samples
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

#install.packages("devtools")
#devtools::install_github("MRCIEU/TwoSampleMR")
#devtools::install_github("MRCIEU/MRInstruments")

library(TwoSampleMR)
library(MRInstruments)
library(data.table)
library(xlsx)

# ---------------------------------------------
#
# Load data & Harmonize & MR
#

#ieugwasr::api_status()
#ao <- available_outcomes()

source("runMR.R")



# ---------------------------------------------
#
# Print results
#



tmp = lapply(mranalysis, function(x) lapply(x, function(k) k[['mr_res']][2,]))
tmp = lapply(tmp, function(x) do.call(rbind,x))
resIVW = do.call(rbind,tmp)

tmp = lapply(mranalysis, function(x) lapply(x, function(k) k[['pleiotropy']]))
tmp = lapply(tmp, function(x) do.call(rbind,x))
resIVW$pval_egger_intercept = do.call(rbind,tmp)[,'pval']

resIVW = resIVW[!resIVW$exposure %in% c("AIS", "AS", "CES"),-c(1,2)]


write.table(resIVW,
            file = "resMRIVW.tab",
            sep = "\t",
            col.names = T,
            row.names = F,
            )

write.xlsx(resIVW,
           file = "resMRIVW.xlsx",
           col.names = T,
           row.names = F,
)




