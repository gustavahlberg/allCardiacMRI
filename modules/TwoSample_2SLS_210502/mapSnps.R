library(bigreadr)
library(bigsnpr)
library(doParallel)

# ------------------------------
#
# map snps
#
# ------------------------

snplist <- read.table("rsIds.txt")

snplist <- split(snplist, snplist$V2)
ukbPath <- '/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/'

names(snplist)


list_snp_id <- foreach(chr = names(snplist)) %dopar% {
    
    cat("Processing chromosome", chr, "..\n")
    mfi <- paste0(ukbPath, "ukb_mfi_chr", chr, "_v3.txt")
    infos_chr <- bigreadr::fread2(mfi, showProgress = FALSE)
    infos_chr$chr <- chr 
    infos_chr_sub <- infos_chr[infos_chr$V2 %in% snplist[[chr]]$V1,]

    write.table(file = paste0("data/SnpsUKB",chr,".txt"),
                infos_chr_sub[,2],
                col.names = F,
                row.names = F,
                quote = F)

    infos_chr_sub

}


do.call(rbind, list_snp_id)


tmp <- do.call(rbind, list_snp_id)
dim(tmp)
snplist <- read.table("rsIds.txt")

snplist[!snplist$V1 %in% tmp$V2,]
