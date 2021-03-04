# ----------------------------------
#
# 1) select snps & make snp matrix
#
# ----------------------------------

## sumstat = read.table("/home/projects/cu_10039/people/stafre/PRS_SCT/data/sumstats/sumstats.tsv",
##                      stringsAsFactors = F,
##                      header = T) %>% rename(chr = CHR,
##            pos = POS)


sumstat = read.table("data/AF_GWAS_ALLv31_maf0.01.txt.gz",
                     stringsAsFactors = F,
                     header = T)


sumstat = sumstat[sumstat$P.value < 0.05,]
sumstatList = split(sumstat, sumstat$chr)

# do not use hapmap snps
# info <- readRDS(url("https://github.com/privefl/bigsnpr/raw/master/data-raw/hm3_variants.rds"))
# str(info)
# infoList = split(info, info$chr)

# ----------------------------------
#
# 1) select snps
#
# ----------------------------------


library(doParallel)
detectCores(all.tests = FALSE, logical = TRUE)

registerDoParallel(cl <- makeCluster(4))
ukbPath='/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/'

list_snp_id <- foreach(chr = 1:22) %dopar% {

    
    cat("Processing chromosome", chr, "..\n")
    mfi <- paste0(ukbPath, "ukb_mfi_chr", chr, "_v3.txt")
    infos_chr <- bigreadr::fread2(mfi, showProgress = FALSE)

    infos_chr_sub <- infos_chr[infos_chr$V3 %in% sumstatList[[chr]]$pos,]  ## MAF > 1%
    with(infos_chr_sub, paste(chr, V3, V4, V5, sep = "_"))
}
stopCluster(cl)

sum(lengths(list_snp_id)) 


# ----------------------------------
#
# 2) map snps
#

colnames(sumstat) =  c("rsid", "a0", "a1", "chr", "pos", "beta", "StdErr", "p")
map = do.call(rbind, strsplit(unlist(list_snp_id),"_"))
colnames(map) <- c("chr", "pos", "a0", "a1")
map <- as.data.frame(map)
map$chr <- as.integer(map$chr); map$pos <- as.integer(map$pos)
sumstat$a1 <- toupper(sumstat$a1); sumstat$a0 <- toupper(sumstat$a0) 

info_snp <- snp_match(sumstat, map)

list_snp_id2 <- with(info_snp, paste(chr, pos, a0, a1, sep = "_"))
list_snp_id2 <- split(list_snp_id2, info_snp$chr)


# ----------------------------------------------------
#
# save
#


save(list_snp_id2, info_snp, file = "data/list_snp_id.rda")


# --------------------------------
# 
# selectsamples
#
# -------------------------------

afSamples = read.table("data/sampleList.unrel.etn_191007.tsv",
                       stringsAsFactors = F)
phenoTab = read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                      stringsAsFactors = F,
                      header = T)
exclude = as.character(read.table("../../data/sample2exclude.all.snpTest_200506.list",
                                  stringsAsFactors = F,
                                  header = F)$V1)

samples = unique(c(afSamples$V1, phenoTab$FID))
samples = samples[(!samples %in% exclude)]
sum(!samples %in% h5read(h5.fn,"sample.id")[,1])

samples = samples[samples %in% h5read(h5.fn,"sample.id")[,1]]

# -------------------------
# 
# sort samples

sampleBgen <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
sampleBgen <- sampleBgen[-1, ]
idx_indiv = which(sampleBgen$ID_1 %in% samples)
samplesOrdered <- sampleBgen[which(sampleBgen$ID_1 %in% samples),]

save(idx_indiv, samplesOrdered, file = "data/samplesOrdered.rda")

# --------------------------------
# 
# make big snpr matrix
#
# -------------------------------

## backingfile = paste0("data/afCohort")

## system.time(
##     rds <- bigsnpr::snp_readBGEN(
##                         bgenfiles = glue::glue("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
##                         list_snp_id = list_snp_id2,
##                         backingfile = backingfile,
##                         ind_row = idx_indiv,
##                         bgi_dir = "/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/",
##                         ncores = 10
##                     )
## ) 


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

