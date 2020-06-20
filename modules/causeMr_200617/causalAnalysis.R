#
# Run causal
#
# -----------------------------------------------
#
# configs
#

library(readr)
library(dplyr)
library(cause)
library(data.table)


args <- commandArgs(trailingOnly = TRUE)
exposure = args[1]
outcome = args[2]

#exposure = 'AF'
#outcome = 'laaef'



# -----------------------------------------------
#
# load data
#


sumstats = data.frame(AF="data/AF_sumstat.gcta.tsv.gz",
                      HF="data/HF_sumstat.gcta.tsv.gz",
                      AS="data/stroke.AS.EUR.gcta.tsv.gz",
                      AIS="data/stroke.AIS.EUR.gcta.tsv.gz",
                      CES="data/stroke.CES.EUR.gcta.tsv.gz",
                      lamin="data/rntrn_lamin.gcta.tsv.gz",
                      ilamin="data/rntrn_ilamin.gcta.tsv.gz",
                      lamax="data/rntrn_lamax.gcta.tsv.gz",
                      ilamax="data/rntrn_ilamax.gcta.tsv.gz",
                      latef="data/rntrn_latef.gcta.tsv.gz",
                      laaef="data/rntrn_laaef.gcta.tsv.gz",
                      lapef="data/rntrn_lapef.gcta.tsv.gz",
                      stringsAsFactors = F)

X1 = fread(sumstats[,exposure], stringsAsFactors = F, header = T)
X2 = fread(sumstats[,outcome], stringsAsFactors = F, header = T)


# -----------------------------------------------
#
# merge
#


X <- gwas_merge(X1, X2, snp_name_cols = c("SNP", "SNP"),
                beta_hat_cols = c("b", "b"),
                se_cols = c("se", "se"),
                A1_cols = c("A1", "A1"),
                A2_cols = c("A2", "A2"))



# -----------------------------------------------
#
# Calculate nuisance parameters
#


set.seed(100)
varlist <- with(X, sample(snp, size=1000000, replace=FALSE))
params <- est_cause_params(X, varlist)




# -----------------------------------------------
#
# LD pruning
#


pruned.fn = paste0("catprunedSnps/pruned.",exposure,"_",outcome,"_all.txt")
pruned = read.table(pruned.fn,
                    stringsAsFactors = F,
                    header = F)


# -----------------------------------------------
#
# Fit CAUSE
#


res <- cause(X=X, variants = pruned$V1, param_ests = params)


# -----------------------------------------------
#
# save results
#


res.fn = paste0("causalResults/rescausal_",exposure,"_",outcome,".Rdata")
save(res, file = res.fn)



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
