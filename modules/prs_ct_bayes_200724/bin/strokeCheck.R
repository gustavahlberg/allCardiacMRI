# ----------------------------------
#
# check PRS association to stroke
#
# ---------------------------------
#
# load
#


library(bigsnpr)
library(rhdf5)
library(lubridate)

ukbbphenoPath = '/home/projects/cu_10039/data/UKBB/phenotypeFn/'
h5.fn <- paste(ukbbphenoPath,"ukb41714.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")[,1]


sampleList = read.table("../../data/AFpheno.unrel.etn_191007.tsv",
                        stringsAsFactors = F,
                        header = T)

df = data.frame(sample.id =  sample.id,
                stringsAsFactors = F)

rownames(df) <- df$sample.id

# ---------------------------------------------
#
# sex
#

h5readAttributes(h5.fn,"f.22001")
df$sex = h5read(h5.fn,"f.22001/f.22001")[,1]


# ---------------------------------------------
#
# age
#

df$age = h5read(h5.fn,"f.21003/f.21003")[,1]

h5readAttributes(h5.fn,"f.34")
df$YofBirth = h5read(h5.fn,"f.34/f.34")

h5readAttributes(h5.fn,"f.52")
df$MofBirth = h5read(h5.fn,"f.52/f.52")

df$dateOfBirth = as.Date(paste(df$YofBirth, df$MofBirth, "01", sep = "-"),
                         format = "%Y-%m-%d")


# ---------------------------------------------
#
# height & weight
# Body Surface Area (BSA) (Dubois and Dubois) = 
# 0.007184 x (patient height in cm)0.725 x (patient weight in kg)0.425

# height
df$height =  h5read(h5.fn,"f.50/f.50")[,1]
# weight
df$weight =  h5read(h5.fn,"f.21002/f.21002")[,1]
#bsa
df$bsa =  0.007184*(df$height^0.725) * (df$weight^0.425)



# ---------------------------------------------
#
# stroke
#

h5readAttributes(h5.fn,"f.42007")
df$stroke = h5read(h5.fn,"f.42007/f.42007")

h5readAttributes(h5.fn,"f.42006")
df$dateOfstroke = as.Date(h5read(h5.fn,"f.42006/f.42006"), format = "%Y-%m-%d")
df$dateOfstroke[which(df$dateOfstroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA

df$ageAtStroke = round(time_length(difftime(df$dateOfstroke, df$dateOfBirth), "years"))



# ---------------------------------------------
#
# ischemic stroke
#

h5readAttributes(h5.fn,"f.42009")
df$IschStroke = h5read(h5.fn,"f.42009/f.42009")

h5readAttributes(h5.fn,"f.42008")
df$dateOfIschStroke = as.Date(h5read(h5.fn,"f.42008/f.42008"), format = "%Y-%m-%d")
#df$dateOfIschStroke[which(df$dateOfIschStroke == as.Date('1900-01-01',format = "%Y-%m-%d"))] <- NA

df$ageAtIschStroke = round(time_length(difftime(df$dateOfIschStroke, df$dateOfBirth), "years"))



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


df = df[(df$sample.id %in% as.character(sampleList$sample.id)),]

dim(df[!df$sample.id %in% phenoTab$FID,])

table(df[!df$sample.id %in% phenoTab$FID,]$stroke)
table(df[!df$sample.id %in% phenoTab$FID,]$IschStroke)

table(df[df$sample.id %in% phenoTab$FID,]$stroke)
table(df[df$sample.id %in% phenoTab$FID,]$IschStroke)

df = df[!df$sample.id %in% phenoTab$FID,]

set.seed(1234)
controlSamples = sample(df$sample.id[df$stroke == -9999], size = sum(df$stroke != -9999)*4)
caseSamples = df$sample.id[df$stroke != -9999]

dfStroke = df[c(caseSamples, controlSamples),]


# -------------------------
# 
# sort df
#
# ------------------------


sample <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
sample <- sample[-1, ]
idx_strokeDF = which(sample$ID_1 %in% dfStroke$sample.id)

dfStroke = dfStroke[as.character(sample$ID_1[idx_strokeDF]),]


save(dfStroke, file = "data/dfStroke.rda")


# -------------------------
# 
# make big snpr matrix
#
# ------------------------

pheno = 'laaef'

sample <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
str(sample)
(N <- readBin("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr10_v3.bgen",what = 1L, size = 4, n = 4)[4])
sample <- sample[-1, ]
nrow(sample) == N

load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)


idx_strokeDF = which(sample$ID_1 %in% dfStroke$sample.id)

backingfile = paste0("data/stroke_prs_",pheno)


system.time(
  rds <- bigsnpr::snp_readBGEN(
    bgenfiles = glue::glue("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
    list_snp_id = list_snp_id,
    backingfile = backingfile,
    ind_row = idx_strokeDF,
    bgi_dir = "/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/",
    ncores = 10
  )
) 


#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################




