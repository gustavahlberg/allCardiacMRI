


samplekey <- read.table("sample_key.txt",
                        header = T)

outliers <- read.table("data/outlier/outlier.bulk")
samplekey$included <- 1

samplekey$included[as.character(samplekey$sample.id) %in% as.character(outliers$V1)] <- 0

tab1 <- read.table("../../../cardiacMRI/modules/analyseImages_191107/results/table_atrial_volume_all.csv", header = T, sep = ",")


tab2 <- read.table("../../../repCardiacMRI/modules/analyseImages_200220/results/table_atrial_volume_all.csv", header = T, sep = ",")

tab <- rbind(tab1, tab2)
tab <-tab[!duplicated(tab$X),]
rownames(tab) <- tab$X


pre <- c("3N CS HN ZK", "ZQ FU 3H EP", "UB XU 9H 6T", "3E 7P X6 YZ",
         "XU 67 NK 7T", "KK 6B 6P 8D", "SA MX SC ZY", "7Z A9 5M PQ",
         "3T 7Z BQ J6", "UZ 9T J6 33", "P2 9S A8 KD")



sum(samplekey$mri.id %in% pre)


samplesPre <- samplekey[samplekey$mri.id %in% pre,]

ids <- samplekey$sample.id[samplekey$mri.id %in% pre ]

cbind(samplesPre, tab[as.character(ids), c("LAV.min..mL.", "LAV.max..mL.")])
