# ----------------------------------
#
# 1) select snps
#
# ----------------------------------



library(doParallel)
detectCores(all.tests = FALSE, logical = TRUE)

registerDoParallel(cl <- makeCluster(4))
ukbPath='/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/'

system.time({
  list_snp_id <- foreach(chr = 1:22) %dopar% {
    cat("Processing chromosome", chr, "..\n")
    mfi <- paste0(ukbPath,"ukb_mfi_chr", chr, "_v3.txt")
    infos_chr <- bigreadr::fread2(mfi, showProgress = FALSE)
    infos_chr_sub <- subset(infos_chr, V6 > 0.01)  ## MAF > 1%
    bim <- paste0("/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497/ukb_snp_chr", chr, "_v2.bim")
    map_chr <- bigreadr::fread2(bim)
    joined <- dplyr::inner_join(
                         infos_chr_sub, map_chr,
                         by = c("V3" = "V4", "V4" = "V5", "V5" = "V6")
                     )
    with(joined, paste(chr, V3, V4, V5, sep = "_"))
  }
}) # 80 sec
stopCluster(cl)

sum(lengths(list_snp_id))  # 656,060

# ----------------------------------------------------
#
# check if in subset bgen
#

list_snp_id.bakk <- list_snp_id


for(i in 1:22) {
    cmd = paste("bash bin/printBgenSnpList.sh ", i)
    system(cmd)
    inbgen = bigreadr::fread2("tmp")
    inbgenID = with(inbgen, paste(i, position, first_allele,alternative_alleles,sep = "_"))
    list_snp_id[[i]] <- list_snp_id[[i]][list_snp_id[[i]] %in% inbgenID]
}


#length(list_snp_id[[i]][!list_snp_id[[i]] %in% inbgenID])
#length(list_snp_id[[i]])

lengths(list_snp_id.bakk) - lengths(list_snp_id)

# ----------------------------------------------------
#
# save
#



save(list_snp_id, file = "data/list_snp_id.RDA")



#tmp = list_snp_id[[i]][!list_snp_id[[i]] %in% inbgenID]

#for(i in 1:22)
#    print(length(readRDS(paste0('../../data/subsetbgen/subset_ukb_imp_chr',i,'_v3_not_found.rds'))))


#########################################
# EOF # EOF ## EOF ## EOF ## EOF ## EOF #
#########################################



