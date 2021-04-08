library(xlsx)
library("irr")


samplekey <- read.table("sample_key.txt",
                        header = T)

outliers <- read.table("data/outlier/outlier.bulk")
samplekey$included <- 1

samplekey$included[as.character(samplekey$sample.id) %in% as.character(outliers$V1)] <- 0
samplekey$mri.id <- gsub("\\s+", "", samplekey$mri.id)

tab1 <- read.table("../../../cardiacMRI/modules/analyseImages_191107/results/table_atrial_volume_all.csv", header = T, sep = ",")


tab2 <- read.table("../../../repCardiacMRI/modules/analyseImages_200220/results/table_atrial_volume_all.csv", header = T, sep = ",")

tab <- rbind(tab1, tab2)
tab <-tab[!duplicated(tab$X),]
rownames(tab) <- tab$X


res <- read.xlsx("Inter.xlsx", sheetIndex = 1)
res$ID <- gsub("\\s+", "", res$ID)





sum(samplekey$mri.id %in% pre)


samplesPre <- samplekey[samplekey$mri.id %in% res$ID, ]

tabsub <- cbind(samplesPre, tab[as.character(samplesPre$sample.id),
                                c("LAV.min..mL.", "LAV.max..mL.")])


merge(res, tabsub, by.x = "ID", by.y = "mri.id")
