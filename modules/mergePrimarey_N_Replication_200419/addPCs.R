#
#
#  Add new pca's from flashPCA model
#
# ---------------------------------------------
#
# load tabel
#


newpca = read.table("../flashpca_200419/results/ukbMriSubset.FlashPca.all.txt",
                    stringsAsFactors = F,
                    header = T)


loadings = read.table("../flashpca_200419/loadings.txt",
                      stringsAsFactors = F,
                      header = T)



dim(newpca); dim(bolt)
all(newpca$IID %in% bolt$IID )
rownames(newpca) <- as.character(newpca$FID)



# ---------------------------------------------
#
# add
#

newpca = newpca[as.character(bolt$FID),]
all(newpca$FID == bolt$FID)
idxNA = which(is.na(bolt$PC1))

plot(bolt$PC1[-idxNA], bolt$PC2[-idxNA])
plot(newpca$PC1[-idxNA],newpca$PC2[-idxNA])



bolt[,paste0("PC",1:10)] <- newpca[,paste0("PC",1:10)]
plot(bolt$PC1, bolt$PC2)



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
