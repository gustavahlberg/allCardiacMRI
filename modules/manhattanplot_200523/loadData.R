#
# load data
#
# ---------------------------------------------

gwas = fread(sumstatsLA, stringsAsFactors = F, header = T)
gwas = data.frame(gwas, stringsAsFactors = F)

gwas$Neg_logP = -log10(gwas$P_BOLT_LMM)
gwas$type = rep("typed",dim(gwas)[1])



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################

#gwas4 = gwas[gwas$CHR == 4,]
#gwas4[which.min(gwas4$P_BOLT_LMM),]
