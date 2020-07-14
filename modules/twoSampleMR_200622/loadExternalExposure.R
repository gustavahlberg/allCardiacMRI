#
#
# Load external outcome data
#
# ---------------------------------------------


if(extGwa == "HF") {
  var = HFvar
} else{ var = AF_stroke_var}


externalgwas.fn = extneralGwas[,extGwa]
gwas = fread(externalgwas.fn, stringsAsFactors = F, header = T)
gwas = data.frame(gwas, stringsAsFactors = F)

gwas = data.frame(SNP = gwas[,var[2]],
                  beta = gwas[, var[3]],
                  se = gwas[, var[4]],
                  effect_allele = gwas[, var[5]],
                  other_allele = gwas[, var[6]],
                  pval = gwas[, var[7]],
                  samplesize = NextGwas[extGwa],
                  Phenotype = extGwa,
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




