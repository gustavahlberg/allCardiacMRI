#
#
# load qctables etc
#
# ---------------------------------------------
#
# load tables
#


sqc_file = "~/Projects_2/ManageUkbb/data/RelatednessETC/ukb_sqc_v2.txt.gz"
hdr_file = "~/Projects_2/ManageUkbb/data/RelatednessETC/colnames"
fam_file = "~/Projects_2/ManageUkbb/data/RelatednessETC/ukb43247_cal_chr1_v2_s488282.fam"


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


qcTab = fread("~/Projects_2/ManageUkbb/data/RelatednessETC/geneticSampleLevel_QCs_190527.tsv.gz",
              header = T,
              stringsAsFactors = F)


