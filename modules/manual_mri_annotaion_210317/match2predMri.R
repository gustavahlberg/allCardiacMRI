library(xlsx)
library("irr")


samplekey <- read.table("sample_key_2.txt",
                        header = T)

outliers <- read.table("data/outlier2/outlier.bulk")
samplekey$included <- 1

samplekey$included[as.character(samplekey$sample.id) %in% as.character(outliers$V1)] <- 0
samplekey$mri.id <- gsub("\\s+", "", samplekey$mri.id)

tab1 <- read.table("../../../cardiacMRI/modules/analyseImages_191107/results/table_atrial_volume_all.csv", header = T, sep = ",")


tab2 <- read.table("../../../repCardiacMRI/modules/analyseImages_200220/results/table_atrial_volume_all.csv", header = T, sep = ",")

tab <- rbind(tab1, tab2)
tab <-tab[!duplicated(tab$X),]
rownames(tab) <- tab$X


res <- read.xlsx("Inter_final.xlsx", sheetIndex = 1)
res$ID <- gsub("\\s+", "", res$ID)



#sum(samplekey$mri.id %in% pre)


samplesPre <- samplekey[samplekey$mri.id %in% res$ID, ]

all(samplesPre$sample.id ==  tab[as.character(samplesPre$sample.id), ]$X)

tabsub <- cbind(samplesPre, tab[as.character(samplesPre$sample.id),
                                c("LAV.min..mL.", "LAV.max..mL.")])


tabres <- merge(res, tabsub, by.x = "ID", by.y = "mri.id")


tabres <- tabres[order(tabres$included), ]
tabres$Biplane_LAmin[tabres$Biplane_LAmin %in% "-"] <- NA
tabres$Biplane_LAmax[tabres$Biplane_LAmax %in% "-"] <- NA


df <- tabres[tabres$included == 1 , c("Biplane_LAmin", "LAV.min..mL.") ]

df <- df[rowSums(is.na(df)) < 1, ]
df$Biplane_LAmin <- as.numeric(df$Biplane_LAmin)

icc(df)


df <- tabres[tabres$included == 1 , c("Biplane_LAmax", "LAV.max..mL.") ]
df <- df[rowSums(is.na(df)) < 1, ]
df$Biplane_LAmax <- as.numeric(df$Biplane_LAmax)

icc(df)


tabres[tabres$included == 0 , ]$Comment
tabres[tabres$included == 1 , ]$Comment



write.table(file = "InterResults.tsv",
            x = tabres,
            quote = T,
            col.names = T,
            row.names = F,
            sep = "\t")
