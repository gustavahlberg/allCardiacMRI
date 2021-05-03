# ---------------------------------------------
#
# Load data
#
# ---------------------------------------------
#
# load sample lists
#

afSamples <- read.table("data/sampleList.unrel.etn_191007.tsv",
                        stringsAsFactors = F)


# afSamples <- read.table("../prs_AF_200813/data/sampleList.unrel.etn_191007.tsv",
#                        stringsAsFactors = F)


phenoTab <- read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                      stringsAsFactors = F,
                      header = T)
exclude <- as.character(read.table("../../data/sample2exclude.all.snpTest_200506.list",
                                  stringsAsFactors = F,
                                  header = F)$V1)

samples <- unique(c(afSamples$V1, phenoTab$FID))
samples <- samples[(!samples %in% exclude)]

sum(!samples %in% h5read(h5.fn,"sample.id")[,1])

samples <- samples[samples %in% h5read(h5.fn,"sample.id")[,1]]
load(file = "data/dfAF.rda", verbose = T)



# ---------------------------------------------
#
# sort
#


sampleBgen <- bigreadr::fread2("data/ukb43247_imp_chr1_v3_s487320.sample")
#sampleBgen <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
sampleBgen <- sampleBgen[-1, ]
idx_indiv <- which(sampleBgen$ID_1 %in% samples)
samplesOrdered <- sampleBgen[which(sampleBgen$ID_1 %in% samples), ]


sum(!samples %in% h5read(h5.fn,"sample.id")[,1])


save(idx_indiv, samplesOrdered, file = "data/samplesOrdered.rda")



# ---------------------------------------------
#
# load variant table
#

varTab <- read.table("data/sentinel_all_trans.dosage",
                     header = T)

dim(varTab)

rownames(varTab) <- c("A1", "A0", as.character(sampleBgen$ID_1))
#varTab


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
