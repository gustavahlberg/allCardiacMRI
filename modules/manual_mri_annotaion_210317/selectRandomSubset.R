# ----------------------------------------------------
#
# select random subset n=200
# select random subset outliers 
#
# ----------------------------------------------------


sample2Exlcude_fn <- "../../data/sample2exclude.all.snpTest_200506.list"

phenofn <- "../../data/ukbCMR.all.boltlmm_210316.sample"
samplelist_fn <- "../../data/sampleList.all.etn_200506.tsv"
primTabAtria_fn <- "/home/projects/cu_10039/projects/cardiacMRI/modules/extrct_atrialVol_200106/results/table_atrial_annotations_all.csv"

repTabAtria_fn <- "/home/projects/cu_10039/projects/repCardiacMRI/modules/extrct_atrialVol_200225/results/rep_table_atrial_annotations_all.csv"



# load
pheno <- read.table(phenofn,
                    header = T)
rownames(pheno) <- pheno$IID
samplelist <- as.character(read.table(samplelist_fn, header = F)$V1)
samples2exclude <- as.character(read.table(sample2Exlcude_fn, header = F)$V1)


primTabAtria <- read.table(primTabAtria_fn, header = T)
repTabAtria <- read.table(repTabAtria_fn, header = T)

tab_atria <- rbind(primTabAtria, repTabAtria)




# ----------------------------------------------------
#
# 
# 


library(xlsx)
inter <- read.xlsx("Inter.xlsx",
                   sheetIndex = T)


sum(is.na(pheno$rntrn_lamax))
sum(is.na(pheno$lamax))

idxPhenoExl <- which(is.na(pheno$rntrn_lamax) & !is.na(pheno$lamax))
samplesPhenoExl <- rownames(pheno)[idxPhenoExl]


outlier <- read.table("data/outlier/outlier.bulk", header = F)


rangeLamax <- range(pheno$lamax, na.rm = T)
rangeLamin <- range(pheno$lamin, na.rm = T)

range(tab_atria[as.character(outlier$V1), ]$lamax)
range(tab_atria[as.character(outlier$V1), ]$lamin)



# ----------------------------------------------------
#
# select random subset of included
# 


#samplesInluded <- samplelist[!samplelist %in% samples2exclude]
#randIncluded <- sample(samplesInluded, size = 200, replace = F)



# ----------------------------------------------------
#
# select random subset of filtered
# 



mriFiltered <- as.character(tab_atria$sample.id[tab_atria$sample.id %in% samples2exclude])
phenoOutlier <- pheno[mriFiltered, ]

length(phenoOutlier$IID[is.na(phenoOutlier$lamax)])


samplesOutlier <- as.character(phenoOutlier$IID[is.na(phenoOutlier$lamax)])

tabOutlier <- tab_atria[samplesOutlier, ]

range(tabOutlier$lamax)
range(tabOutlier$lamin)




tabLaminLamaxOutlier <- tabOutlier[(tabOutlier$lamax < rangeLamax[1] | tabOutlier$lamax > rangeLamax[2] | tabOutlier$lamin < rangeLamin[1] | tabOutlier$lamin > rangeLamin[2]), ]


randOutlier <- sample(tabLaminLamaxOutlier$sample.id, size = 200, replace = F)



# ----------------------------------------------------
#
# print 
# 


write.table(x = randIncluded,
            file = "data/included/included.bulk",
            col.names = F,
            row.names = F,
            quote = F)


write.table(x = randOutlier,
            file = "data/outlier2/outlier.bulk",
            col.names = F,
            row.names = F,
            quote = F)



#############################################


