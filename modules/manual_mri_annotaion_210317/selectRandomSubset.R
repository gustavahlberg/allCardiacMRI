# ----------------------------------------------------
#
# select random subset n=200
# select random subset outliers 
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
# select random subset of included
# 


samplesInluded <- samplelist[!samplelist %in% samples2exclude]


randIncluded <- sample(samplesInluded, size = 200, replace = T)




# ----------------------------------------------------
#
# select random subset of filtered
# 



mriFiltered <- as.character(tab_atria$sample.id[tab_atria$sample.id %in% samples2exclude])
phenoOutlier <- pheno[mriFiltered, ]

length(phenoOutlier$IID[is.na(phenoOutlier$lamax)])


samplesOutlier <- phenoOutlier$IID[is.na(phenoOutlier$lamax)]



randOutlier <- sample(samplesOutlier, size = 200, replace = T)



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
            file = "data/outlier/outlier.bulk",
            col.names = F,
            row.names = F,
            quote = F)



#############################################


