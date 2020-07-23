# ----------------------------------
#
# 2) samples
#
# --------------------------------------------------
#
# load
#

source("bin/loadQCtables.R")

phenoTab = read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                      stringsAsFactors = F,
                      header = T)

exclude = as.character(read.table("../../data/sample2exclude.all.snpTest_200506.list",
                                  stringsAsFactors = F,
                                  header = F)$V1)
related = as.character(read.table("../flashpca_200419/results/related4_dgrs_200507.txt",
                                  stringsAsFactors = F,
                                  header = F)$V1)

# training samples
trainingSamples = as.character(read.table("../../../cardiacMRI/data/sampleList.etn_200219.tsv",
                                          stringsAsFactors = F,
                                          header = F)$V1)

# test samples
testSamples = as.character(read.table("../../../repCardiacMRI/data/sampleList.etn_200506.tsv",
                                      stringsAsFactors = F,
                                      header = F)$V1)


# double check sample files
sample <- bigreadr::fread2("../../data/ukbCMR.all.snpTest_200506.sample")
str(sample)
(N <- readBin("../../data/subsetbgen/subset_ukb_imp_chr22_v3.bgen", what = 1L, size = 4, n = 4)[4])
sample <- sample[-1, ]
nrow(sample) == N



# --------------------------------------------------
#
# subsets index, test train 
#


length(unique(c(exclude, related)))
samples2exclude = unique(c(exclude, related))

sum(phenoTab$FID %in% samples2exclude)
ind.indiv = which(!phenoTab$FID %in% samples2exclude)


which(as.character(phenoTab$FID[ind.indiv]) %in% trainingSamples)

ind.train <- which(as.character(phenoTab$FID[ind.indiv]) %in% trainingSamples)
ind.test <- which(as.character(phenoTab$FID[ind.indiv]) %in% testSamples)



  
