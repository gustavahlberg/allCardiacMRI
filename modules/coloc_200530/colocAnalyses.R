#
# run coloc
#
# --------------------------------------
#
# settings
#

H4thres = 0.75
#colocList = list()


# ---------------------------------------------
#
# loop atrial appendage
#



source("colocAtrialAppendage.R")
lengths(aaColocList)

lapply(aaColocList, function(x) lapply(x, function(z) z[1]))

# ---------------------------------------------
#
# loop left ventricle
#


source("colocLeftVentricle.R")
lapply(lvColocList, function(x) lapply(x, function(z) z[1]))


#######################################################
# EOF # # EOF # # EOF # # EOF # # EOF # # EOF # # EOF #
#######################################################
