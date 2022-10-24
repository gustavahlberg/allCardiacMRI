# ---------------------------------------------
#
# Variable selection for predicting LA volume&function
#
# ---------------------------------------------
#
# data
#


phenoTab <- read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                       stringsAsFactors = F,
                       header = T)


load(file = "dataFrame_210503.rda")

