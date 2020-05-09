#
# Run king robust and partition relate unrelated
#
# --------------------------------------------------------
#
# load
#

#BiocManager::install("GWASTools")
#BiocManager::install("GENESIS")

library(GENESIS)
library(GWASTools)        
library(SNPRelate)


bed="intermediate/ukbMriSubset.maf.reg1.reg.bed"
fam="intermediate/ukbMriSubset.maf.reg1.reg.fam"
bim="intermediate/ukbMriSubset.maf.reg1.reg.bim"
gds.fn="intermediate/ukbMriSubset.maf.reg1.reg.gds"

# --------------------------------------------------------
#
# make gds
#


## snpgdsBED2GDS(bed.fn = bed,
##               bim.fn = bim,
##               fam.fn = fam,
##               out.gdsfn = gds.fn)


# --------------------------------------------------------
#
# Run king
#



genofile <- snpgdsOpen(gds.fn)

ibd.robust <- snpgdsIBDKING(genofile, type = "KING-robust",
                            maf = 0.01, missing.rate = 0.02,
                            num.thread = 20)
snpgdsClose(genofile)
print("King done")
date =  format(Sys.time(), "%y%m%d")
save(file = paste0("results/ibd.kingrobust_", date,".rda.gz"),
     ibd.robust,
     compress = TRUE)


# --------------------------------------------------------
#
# Partition 
#


# load("results/ibd.kingrobust_200507.rda.gz")
#KINGmat <- kingToMatrix(ibd.robust)
ibd.robust$IBS0 <- 0
KINGmat <- ibd.robust$kinship
dimnames(KINGmat) <- list(ibd.robust$sample.id, ibd.robust$sample.id)
remove(ibd.robust)

save(file = paste0("results/KINGmat", date,".rda.gz"),
     KINGmat,
     compress = TRUE)


load("results/KINGmat200507.rda.gz")

deg2 = 1/(2^(7/2))
deg4 =  2^(-11/2) 
thres = deg2
part2nd <- pcairPartition(kinobj = KINGmat,
                          divobj = KINGmat,
                          kin.thresh = thres,
                          )
thres = deg4
part4th <- pcairPartition(kinobj = KINGmat,
                          divobj = KINGmat,
                          )


# -------------------------------------------
#
# Print list of > 4 degrees related
# Print list of > 2 degrees related
# & save relationship matrices
# 

date =  format(Sys.time(), "%y%m%d")

write.table(x = part4th$rels,
                        file = paste0("results/related4_dgrs_", date,".txt"),
                        row.names = F,
                        col.names = F,
                        quote = F)

write.table(x = part2nd$rels,
                        file = paste0("results/related2_dgrs_", date,".txt"),
                        row.names = F,
                        col.names = F,
                        quote = F)


save(file = "results/partitions4th_200507.rds",part4th)
save(file = "results/partitions2nd_200507.rds",part2nd)


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

