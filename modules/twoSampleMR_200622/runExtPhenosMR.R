#
#
# run MR w/ external gwas as exposures
#
# ---------------------------------------------





for(extGwa in names(NextGwas)) {
  
  mranalysis[[extGwa]] <- list()
  source("loadExternalExposure.R")
  
  for (laphenos.fn in laphenos.fns) {
    
    pheno = gsub("rntrn_|.bgen.stats.betastd.tsv.gz","",basename(laphenos.fn))
    # load la phenos outcome
    outcome_dat <- read_outcome_data(
      snps = exp_dat$SNP,
      filename = laphenos.fn,
      sep = "\t",
      snp_col = 'SNP',
      beta_col = 'bstd',
      se_col = 'sestd',
      effect_allele_col = 'ALLELE1',
      other_allele_col = 'ALLELE0',
      eaf_col = "A1FREQ",
      pval_col = "P_BOLT_LMM"
    )
    
    outcome_dat$outcome = pheno
    
    
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

    mranalysis[[extGwa]][[pheno]] <-  list(data = dat, mr_res = mr_res, pleiotropy= pleiotropy)
    
  }
}







