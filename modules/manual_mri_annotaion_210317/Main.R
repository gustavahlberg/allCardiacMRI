#
#
# Manual annotation of CMR & counting
# 
# 1. count excluded cmr's in different steps
# 2. pair manual annotations
# 3. ICC & Bland Altman plot
# ---------------------------------------------
#
# Set relative path an source environment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


source("bin/load.R")



# ---------------------------------------------
#
# 1. count excluded cmr's in different steps
#

source("bin/countExcluded.R")

# ---------------------------------------------
#
# 2. pair manual annotations
#

source("match2predMri.R")

# ---------------------------------------------
#
# 3. ICC & Bland Altman plot
#


source("bin/blandAltmanPlot.R")


#############################################
# EOF # # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################