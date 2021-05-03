# ---------------------------------------------
#
# count excluded cmr's in different steps
#
# ---------------------------------------------
#
# 1. annotate atrial phase IO's
# 2. filtered measurements
#
# start: long axis 44,313 & short axis 44,142 listed
#
# ---------------------------------------------
#
# 1. annotate atrial phase IO's
#

primInFn <- "../../../cardiacMRI/modules/extrct_atrialVol_200106/results/table_atrial_volume_all.csv"
repInFn <- "../../../repCardiacMRI/modules/extrct_atrialVol_200225/results/rep_table_atrial_volume_all.csv"
primAnInFn <- "../../../cardiacMRI/modules/extrct_atrialVol_200106/results/table_atrial_annotations_all.csv"
repAnInFn <- "../../../repCardiacMRI/modules/extrct_atrialVol_200225/results/rep_table_atrial_annotations_all.csv"

primIn = read.csv(primInFn,
                  stringsAsFactors = F,
                  header = T)
repIn = read.csv(repInFn,
                 stringsAsFactors = F,
                 header = T)
primAnIn = read.table(primAnInFn,
                  stringsAsFactors = F,
                  header = T,
                  sep = "\t")
repAnIn = read.table(repAnInFn,
                     stringsAsFactors = F,
                     header = T,
                     sep = "\t")

nExclAnn <- sum(dim(primAnIn)[1] + dim(repAnIn)[1]) - sum(dim(primIn)[1] + dim(repIn)[1])
nAnn <- sum(dim(primIn)[1] + dim(repIn)[1])

# ---------------------------------------------
#
# 2. filter measurements
#


nAfterFilteredPrim <- 29898
nAfterFilteredRep <- 11097

nAfterFiltered <- nAfterFilteredPrim + nAfterFilteredRep
nFiltered <- nAnn - nAfterFiltered


#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################





