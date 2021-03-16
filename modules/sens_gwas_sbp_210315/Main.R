#
#
# Sensitivity analyses w/ SBP accounting for medication 
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


source("bin/load.R")



# ---------------------------------------------
#
# Load data
#


source("bin/loadData.R")



# ---------------------------------------------
#
# SBP var.
#

source("bin/sbp.R")

# ---------------------------------------------
#
# add Valve disease
#

source("bin/icd.R")
source("bin/defValve.R")

all(rownames(Valvepheno) == allTab$FID)
allTab$Valve <- ifelse(rowSums(Valvepheno[,-1]) > 0, 1,0)


# ---------------------------------------------
#
# print
#

write.table(x = allTab,
            file = out.fn,
            col.names = T,
            row.names = F,
            quote = F)


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################






