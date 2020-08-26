# -------------------------
# 
# 3) make pheno df
#

library(bigsnpr)
library(rhdf5)
library(lubridate)
load("data/list_snp_id.rda", verbose = TRUE)
load("data/samplesOrdered.rda", verbose = TRUE)


ukbbphenoPath = '/home/projects/cu_10039/data/UKBB/phenotypeFn/'
h5.fn <- paste(ukbbphenoPath,"ukb41714.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")[,1]

df = data.frame(sample.id =  sample.id,
                stringsAsFactors = F)
rownames(df) <- df$sample.id


# ---------------------------------------------
#
# sex & age
#

h5readAttributes(h5.fn,"f.22001")
df$sex = h5read(h5.fn,"f.22001/f.22001")[,1]
df$age = h5read(h5.fn,"f.21003/f.21003")[,1]


# ---------------------------------------------
#
# def AF
#


source("bin/defAF.R")
df$AF = ifelse(rowSums(AFpheno[,-1]) > 0, 1,0)



# ---------------------------------------------
#
# PC's
#

h5readAttributes(h5.fn,"f.22009")
PCs = h5read(h5.fn,"f.22009/f.22009")[,1:10]
colnames(PCs) <- paste0("PC", 1:10)
df = cbind(df, PCs)


# ---------------------------------------------
#
# subset
#

df = df[as.character(samplesOrdered$ID_1),]
save(df, file = "data/dfAF.rda")


#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################
