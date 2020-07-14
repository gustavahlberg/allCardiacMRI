#
#
# 1) select unrelated sample sets training/test validation
# 
# --------------------------------------------------
#
# load QC tables 
#

source("bin/loadQCtables.R")

# --------------------------------------------------
#
# train/validation
#


source("bin/makeTrainSampleSet.R")


# --------------------------------------------------
#
# test
#


source("bin/makeTestSampleSet.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################