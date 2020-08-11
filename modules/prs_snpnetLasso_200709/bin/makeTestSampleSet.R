#
# select unrelated sample set 
# test
#
# --------------------------------------------------
#
# load
#

phenoTest = read.table("../../../repCardiacMRI/data/ukbCMR.rep.plinkPhenocovar_200509.sample",
                        stringsAsFactors = F,
                        header = T)


related = as.character(read.table("../../../repCardiacMRI/modules/flashpca_200419/results/related4_dgrs_200713.txt",
                                  stringsAsFactors = F,
                                  header = F)$V1)


newPca = read.table("../../../repCardiacMRI/modules/flashpca_200419/results/ukbMriSubset.FlashPca.all.rep.txt",
                    stringsAsFactors = F,
                    header = T)


row.names(newPca) <- as.character(newPca$FID)
all(as.character(newPca$FID) %in% as.character(phenoTest$FID))

# --------------------------------------------------
#
# add new pc's
#

all(newPca[as.character(phenoTest$FID),]$FID == phenoTest$FID)
newPca = newPca[as.character(phenoTest$FID),]
all(newPca$FID== phenoTest$FI)

header <- colnames(phenoTest)
header[grep("PC",header)] <- paste0("bPC", 1:10)
colnames(phenoTest) <- header

phenoTest = cbind(phenoTest, newPca[, paste0("PC", 1:10)])

# ---------------------------------------
#
# QC check
#

qc_exlucde <- (sqc2$het.missing.outliers==1 &
                 sqc2$excluded.from.kinship.inference==1 &
                 sqc2$excess.relatives==1 #&
               #sqc2$used.in.pca.calculation==1
)

qc2 <- sqc2[qc_exlucde,]
any(phenoTest$FID %in% qc2$eid)



# ---------------------------------------
#
# subset to etnically matched & unrelated
#


phenoTest = phenoTest[!is.na(phenoTest$rntrn_lamax),]
phenoTest = phenoTest[-which(phenoTest$FID %in% related),]


# split col
set.seed(42)
phenoTest$split = "test"
table(phenoTest$split)

phe.fn = paste0("phenoTest_", format(Sys.time(),"%y%m%d"),".phe")

write.table(x = phenoTest,
            file = "data/phenoTest.phe",
            sep = "\t",
            row.names = F,
            col.names = T,
            quote = F)

plot(phenoTest$bPC1,phenoTest$bPC2)


#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
