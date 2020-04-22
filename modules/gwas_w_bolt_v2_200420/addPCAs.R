#
#
#  Add new pca's from flashPCA model
#
# ---------------------------------------------
#
# load table
#

newpca = read.table("../flashpca_200419/results/ukbMriSubset.FlashPca.txt",
                                        stringsAsFactors = F,
                                        header = T)
snpTestDF = read.table("../../data/ukbCMR.all.snpTest_200419.sample",
                       stringsAsFactors = F,
                       header = T)
boltDF = read.table("../../data/ukbCMR.all.boltlmm_200419.sample",
                    stringsAsFactors = F,
                    header = T)


#loadings = read.table("../fastPpca_200220/results/loadings.txt",
#                                          stringsAsFactors = F,
#                                         header = T)


dim(newpca); dim(snpTestDF)
all(newpca$IID %in% snpTestDF$ID_1 )
all(newpca$IID %in% boltDF$FID)
rownames(newpca) <- as.character(newpca$FID)


# ---------------------------------------------
#
# add pc to snp test
#

header = snpTestDF[1,]
snpTestDF = snpTestDF[-1,]
newpca = newpca[as.character(snpTestDF$ID_1),]
all(newpca$FID == snpTestDF$ID_1)
#idxNA = which(is.na(snptestDF$PC1))

#plot(snptestDF$PC1[-idxNA],snptestDF$PC2[-idxNA])
#plot(newpca$PC1[-idxNA],newpca$PC2[-idxNA])

snpTestDF[,paste0("PC",1:10)] <- newpca[,paste0("PC",1:10)]

snpTestDF = rbind(header, snpTestDF)

write.table(snpTestDF,
            file = "../../data/ukbCMR.all.snpTest_200419.sample",
            col.names = T,
            row.names = F,
            quote = F)

# ---------------------------------------------
#
# add pc to bolt
#

all(newpca$FID == boltDF$FID)
boltDF[,paste0("PC",1:10)] <- newpca[,paste0("PC",1:10)]



write.table(boltDF,
            file = "../../data/ukbCMR.all.boltlmm_200419.sample",
            col.names = T,
            row.names = F,
            quote = F)



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
