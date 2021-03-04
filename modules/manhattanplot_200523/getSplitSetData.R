#
# load data
#
# ---------------------------------------------

set1_path = "../../../cardiacMRI/data/gwasSummaryStats/gwas_rtrn/"
set2_path = "../../../repCardiacMRI/data/gwasSummaryStats/gwas_rtrn/"

phenotabSet2 = read.table("../../../repCardiacMRI/data/ukbCMR.rep.boltlmm_200509.sample",
                      header = T)

phenotabSet1 = read.table("../../../cardiacMRI/data/ukbCMR.boltlmm_200509.sample",
                      header = T)



locusAllList = split(locusAll, locusAll$Pheno)

for(locuspheno in names(locusAllList)) {
  print(locuspheno)
  
  # primary
  sumstatsLA = paste0(set1_path, locuspheno, ".bgen.stats.betastd.tsv.gz")
  gwas = fread(sumstatsLA, stringsAsFactors = F, header = T)
  gwas = data.frame(gwas, stringsAsFactors = F)
  sentrsid = locusAll$sentinel_rsid[locusAll$Pheno == locuspheno]
  gwasLoci <- gwas[gwas$SNP %in% sentrsid,]
  
  idxSamples = which(!is.na(phenotabSet1$rntrn_ilamin))
  sdpheno = sd(phenotabSet1[idxSamples,gsub("rntrn_","", locuspheno)])
  gwasLoci$beta = signif(sdpheno*as.numeric(gwasLoci$bstd), digits = 3)
  gwasLoci$se = signif(sdpheno*as.numeric(gwasLoci$sestd), digits = 3)
  
  rownames(gwasLoci) <- gwasLoci$SNP
  gwasLoci <- gwasLoci[locusAllList[[locuspheno]]$sentinel_rsid,]
  
  locusAllList[[locuspheno]]$pval_set1 <- gwasLoci$P_BOLT_LMM
  locusAllList[[locuspheno]]$beta_set1 <- gwasLoci$beta
  locusAllList[[locuspheno]]$se_set1 <- gwasLoci$se

  # replication
  sumstatsLA = paste0(set2_path, locuspheno, ".bgen.stats.betastd.tsv.gz")
  gwas = fread(sumstatsLA, stringsAsFactors = F, header = T)
  gwas = data.frame(gwas, stringsAsFactors = F)
  sentrsid = locusAll$sentinel_rsid[locusAll$Pheno == locuspheno]
  gwasLoci <- gwas[gwas$SNP %in% sentrsid,]
  
  idxSamples = which(!is.na(phenotabSet2$rntrn_ilamin))
  sdpheno = sd(phenotabSet2[idxSamples,gsub("rntrn_","", locuspheno)])
  gwasLoci$beta = signif(sdpheno*as.numeric(gwasLoci$bstd), digits = 3)
  gwasLoci$se = signif(sdpheno*as.numeric(gwasLoci$sestd), digits = 3)
  
  rownames(gwasLoci) <- gwasLoci$SNP
  gwasLoci <- gwasLoci[locusAllList[[locuspheno]]$sentinel_rsid,]
  
  locusAllList[[locuspheno]]$pval_set2 <- gwasLoci$P_BOLT_LMM
  locusAllList[[locuspheno]]$beta_set2 <- gwasLoci$beta
  locusAllList[[locuspheno]]$se_set2 <- gwasLoci$se
  

}







