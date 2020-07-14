#
#
# run MR w/ la phenotypes as exposures
#
# ---------------------------------------------



for (laphenos.fn in laphenos.fns) {
  
  pheno = gsub("rntrn_|.bgen.stats.betastd.tsv.gz","",basename(laphenos.fn))
  gwas = fread(laphenos.fn, stringsAsFactors = F, header = T)
  mranalysis[[pheno]] <- list()
  
  gwas = data.frame(SNP = gwas$SNP,
                    beta = gwas$bstd,
                    se = gwas$sestd,
                    effect_allele = gwas$ALLELE1,
                    other_allele = gwas$ALLELE0,
                    eaf = gwas$A1FREQ,
                    chr = gwas$CHR,
                    position = gwas$BP,
                    pval = gwas$P_BOLT_LMM,
                    units = "SD",
                    samplesize = N,
                    Phenotype = pheno,
                    stringsAsFactors = F)
  
  gwasSub =  gwas[gwas$pval < pvalthres,]
  exp_dat <- format_data(gwasSub, type="exposure")
  
  exp_dat = clump_data(exp_dat,
                       clump_kb = 10000,
                       clump_r2 = 0.05,
                       clump_p1 = 1,
                       clump_p2 = 1,
                       pop = "EUR"
  )
  
  for(extGwa in names(NextGwas)) {
    source("loadExternalOutcome.R")
    
    #harmonise_data
    dat <- harmonise_data(
      exposure_dat = exp_dat,
      outcome_dat = outcome_dat
    )
    
    #mr
    mr_res = mr(dat, method_list= c("mr_two_sample_ml", 
                                    "mr_ivw",
                                    "mr_weighted_median",
                                    "mr_egger_regression_bootstrap"))
    pleiotropy = mr_pleiotropy_test(dat)
    mranalysis[[pheno]][[extGwa]] <-  list(data = dat, mr_res = mr_res, pleiotropy= pleiotropy)
  
  }
}



