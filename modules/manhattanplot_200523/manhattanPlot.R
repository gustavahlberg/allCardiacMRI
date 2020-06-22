#
# Manhattan plot
#
# ------------------------------------



gwas.fn = gsub(".bgen.stats.gz",".mahattan.tiff",basename(sumstatsLA))
pheno = gsub(".bgen.stats.gz","",basename(sumstatsLA))
gwas$P = gwas$P_BOLT_LMM
gwas_p01 = gwas[gwas$P <= 0.1,]






tiff(gwas.fn,width = 29, height = 21, 
     units = 'cm',
     res = 300)



GWAS_Manhattan(gwas_p01, 
               loci = locusAll[locusAll$Pheno == pheno,],
               add.legend = FALSE)

dev.off()



#####################################################################
# EOF # EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF # 
#####################################################################
