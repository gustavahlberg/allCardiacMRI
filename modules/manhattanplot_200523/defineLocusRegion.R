# 
#
# define locus region
#
# ---------------------------------------------

#pheno = gsub(".bgen.stats.gz","",basename(sumstatsLA))
pheno = gsub(".bgen.stats.betastd.tsv.gz","",basename(sumstatsLA))

loci.fn = paste0("../clumping_200518/results/gwSign_",pheno,"_ALL.clumped")
loci = read.table(loci.fn,
           header = T,
           stringsAsFactors = F)


locusMat = matrix("",ncol = 13,nrow = dim(loci)[1],
                dimnames = list(c(),c("Pheno","sentinel_rsid","sent_pval","chr","bp","startBP","stopBP","totBP",
                                      "ALLELE1","ALLELE0","A1FREQ","bstd", "sestd"))
                )

for (i in 1:dim(loci)[1]){
  
  locus = loci[i,]
  rsid = gsub("\\([1-9]\\)","",unlist(strsplit(locus$SP2,",")))
  locigwas = gwas[gwas$SNP %in% c(locus$SNP, rsid),]
  minBP = min(locigwas$BP)
  maxBP = max(locigwas$BP)
  
  sentinel = locigwas[locigwas$SNP %in% locus$SNP,]
  

  locusMat[i,] = c(pheno,
                   locus$SNP, 
                   locus$P, 
                   unique(locigwas$CHR),
                   locus$BP,
                   minBP, 
                   maxBP,
                   maxBP - minBP,
                   sentinel$ALLELE1,
                   sentinel$ALLELE0,
                   signif(sentinel$A1FREQ, digits = 3),
                   sentinel$bstd,
                   sentinel$sestd
                   )
}

locusMat = as.data.frame(locusMat, stringsAsFactors = F)

# -----------------------------------------
#
# convert betas from standard deviation
#

phenotab = read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                      header = T)
idxSamples = which(!is.na(phenotab$rntrn_ilamin))
sdpheno = sd(phenotab[idxSamples,gsub("rntrn_","",pheno)])
locusMat$beta = signif(sdpheno*as.numeric(locusMat$bstd), digits = 3)
locusMat$se = signif(sdpheno*as.numeric(locusMat$sestd), digits = 3)


# -----------------------------------------
#
# save
#

locusAll = rbind(locusAll,locusMat)


#locusAll$gene = apply(locusAll,1,function(lo) {nearest_gene(lo,genelist)$GENE})




# write.table(locusAll,
#             )


###########################################
# EOF # EOF# EOF# EOF# EOF# EOF# EOF# EOF #
###########################################

