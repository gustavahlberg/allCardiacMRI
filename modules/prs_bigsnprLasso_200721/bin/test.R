# ----------------------------------
#
# 4) run big_spLinReg on test K=10
#
# ----------------------------------


library(bigsnpr)
#pheno = "ilamax"

args = commandArgs(trailingOnly=TRUE)
pheno = args[1]

print(pheno)
