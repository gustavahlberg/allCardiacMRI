#
#
# Load external outcome data
#
# ---------------------------------------------


if(extGwa == "HF") {
  var = HFvar
} else{ var = AF_stroke_var}


externalgwas.fn = extneralGwas[,extGwa]


#outcome
outcome_dat <- read_outcome_data(
  snps = exp_dat$SNP,
  filename = externalgwas.fn,
  sep = var[1],
  snp_col = var[2],
  beta_col = var[3],
  se_col = var[4],
  effect_allele_col = var[5],
  other_allele_col = var[6],
  #eaf_col = "a1_freq",
  pval_col = var[7]
)

outcome_dat$outcome = extGwa
