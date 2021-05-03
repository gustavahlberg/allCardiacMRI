# ---------------------------------------------
#
# Load data
#
# -------------------------------------------


gwas_loci <- list()

phenos = c("ilamin", "ilamax", "laaef", "lapef", "latef")


### loop
for(pheno in phenos) {

  lead.fn = paste0("../clumping_200518/results/gwSign_rntrn_",
                   pheno,
                   "_ALL.clumped")

  gwas.fn <- paste0("../../data/gwas_results/gwas_rtrn/rntrn_"
                    ,pheno, 
                    ".bgen.stats.betastd.tsv.gz")

  gwas = fread(gwas.fn, stringsAsFactors = F, header = T)
  gwas = data.frame(gwas, stringsAsFactors = F)


  loci.fn = paste0("../clumping_200518/results/gwSign_rntrn_",
                   pheno,
                  "_ALL.clumped")
  loci = read.table(loci.fn,
                    header = T,
                    stringsAsFactors = F)


  gwSign <- gwas[gwas$SNP %in% loci$SNP,]

  gwas_loci[[pheno]] <-gwSign

}

#rm 
gwas_loci$ilamax <- gwas_loci$ilamax[!gwas_loci$ilamax$SNP %in% "rs7842765",]


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################

