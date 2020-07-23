#
#
# load qctables etc
#
# ---------------------------------------------
#
# load tables
#


sqc_file = "/home/projects/cu_10039/data/UKBB/RelatednessETC/ukb_sqc_v2.txt.gz"
hdr_file = "/home/projects/cu_10039/data/UKBB/RelatednessETC/colnames"
fam_file = "/home/projects/cu_10039/data/UKBB/RelatednessETC/ukb43247_cal_chr1_v2_s488282.fam"


sqc <- fread(sqc_file,stringsAsFactors=F)
sqc <- data.frame(sqc)
sqc <- sqc[,3:ncol(sqc)]
fam <- fread(fam_file)
fam <- data.frame(fam)
eid <- as.character(fam$V1)

sqc2 <- cbind.data.frame(eid,sqc)

hd <- read.table(hdr_file)
## add sample names
hd <- c(c('eid'),as.character(hd$V1)[1:nrow(hd)])
names(sqc2) <- hd


qcTab = fread("/home/projects/cu_10039/data/UKBB/RelatednessETC/geneticSampleLevel_QCs_190527.tsv.gz",
              header = T,
              stringsAsFactors = F)


