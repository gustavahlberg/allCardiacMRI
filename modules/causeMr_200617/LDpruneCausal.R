#
# LD prune for causal analysis
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
chr = args[3]

#exposure = 'AF'
#outcome = 'laaef'
#chr = 1

pruned.fn = paste0("prunedSnps/pruned.",exposure,"_",outcome,"_chr",chr,".txt")
getwd()

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


X1 <- data.frame(X1, stringsAsFactors = F)
rownames(X1) <- X1$SNP

X$pval1 <- X1[X$snp,]$p 

# -----------------------------------------------
#
# LD pruning
#

ld <- readRDS(paste0("data/chr",chr,"_AF0.05_0.1.RDS"))
snp_info <- readRDS(paste0("data/chr",chr,"_AF0.05_snpdata.RDS"))


pruned <- ld_prune(variants = X,
                   ld = ld,
                   total_ld_variants = snp_info$SNP,
                   pval_cols = c("pval1"),
                   pval_thresh = c(1e-3))


# -----------------------------------------------
#
# Print pruned variants
#


write.table(x = pruned,
            file = pruned.fn,
            col.names = F,
            row.names = F,
            quote = F)

print(paste("Finished", pruned.fn))


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
