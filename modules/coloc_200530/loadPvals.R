#
#  add pvalues to locus tables
#
# ---------------------------


gwPaths = list.files("../../data/gwas_results/gwas_rtrn",full.names = T)


for(gw.fn in gwPaths) {
  
  #gw.fn = gwPaths[1]
  gwas = fread(gw.fn,
               header = T,
               stringsAsFactors = F)  
  
  gwas = data.frame(gwas, stringsAsFactors = F)
  row.names(gwas) <- paste(gwas$CHR, gwas$BP, gwas$ALLELE1, gwas$ALLELE0, sep = "_")

  lociInGw = loci[grep(gsub(".bgen.stats.gz","",basename(gw.fn)), names(loci))]
  
  for(i in 1:length(lociInGw)) {
    lociName = names(lociInGw[i])
    locus = lociInGw[[i]]
    locus$pval = gwas[paste(locus$chromosome, locus$position, locus$allele1, locus$allele2, sep = "_"),]$P_BOLT_LMM
    loci[[lociName]] <- locus
  }
}
  


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
