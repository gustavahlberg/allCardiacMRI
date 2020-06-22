# 
#
# define locus region
#
# ---------------------------------------------

pheno = gsub(".bgen.stats.gz","",basename(sumstatsLA))

loci.fn = paste0("../clumping_200518/results/gwSign_",pheno,"_ALL.clumped")
loci = read.table(loci.fn,
           header = T,
           stringsAsFactors = F)


locusMat = matrix("",ncol = 8,nrow = dim(loci)[1],
                dimnames = list(c(),c("Pheno","sentinel_rsid","sent_pval","chr","bp","startBP","stopBP","totBP"))
                )

for (i in 1:dim(loci)[1]){
  
  locus = loci[i,]
  rsid = gsub("\\([1-9]\\)","",unlist(strsplit(locus$SP2,",")))
  locigwas = gwas[gwas$SNP %in% rsid,]
  minBP = min(locigwas$BP)
  maxBP = max(locigwas$BP)

  locusMat[i,] = c(pheno,locus$SNP, locus$P, unique(locigwas$CHR),
                   locus$BP,
                   minBP, maxBP,
                   maxBP - minBP)
}

locusMat = as.data.frame(locusMat, stringsAsFactors = F)



# -----------------------------------------
#
# save
#

locusAll = rbind(locusAll,locusMat)

###########################################
# EOF # EOF# EOF# EOF# EOF# EOF# EOF# EOF #
###########################################

