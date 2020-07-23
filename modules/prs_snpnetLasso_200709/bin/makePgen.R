#
#
# format train and test to pgen format
# 
# --------------------------------------------------
# Train


phenoTrain = read.table("data/phenoTrain.phe",
                        stringsAsFactors = F,
                        header = T)

fam  = read.table("data/ukbMriSubset.train.psam",
                        stringsAsFactors = F,
                        header = F)


all(phenoTrain$FID %in% fam$V1)
rownames(phenoTrain) <- phenoTrain$FID
phenoTrain = phenoTrain[as.character(fam$V1),]
all(phenoTrain$FID == fam$V1)
all(fam$V5 == phenoTrain$sex)

write.table(phenoTrain,
            file = 'data/phenTrain.sort.phe',
            col.names = T,
            row.names = F,
            quote = F)


# --------------------------------------
# Test


phenoTest = read.table("data/phenoTest.phe",
                        stringsAsFactors = F,
                        header = T)

fam  = read.table("data/ukbMriSubset.test.fam",
                        stringsAsFactors = F,
                        header = F)


all(phenoTest$FID %in% fam$V1)
rownames(phenoTest) <- phenoTest$FID
phenoTest = phenoTest[as.character(fam$V1),]
all(phenoTest$FID == fam$V1)
all(fam$V5 == phenoTest$sex)

write.table(phenoTest,
            file = 'data/phenTest.sort.phe',
            col.names = T,
            row.names = F,
            quote = F)










