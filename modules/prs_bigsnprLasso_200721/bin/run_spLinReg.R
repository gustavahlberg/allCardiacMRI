# ----------------------------------
#
# 4) run big_spLinReg on test K=10
#
# ----------------------------------

try(bigparallelr::set_blas_ncores(1), silent = TRUE)
library(bigsnpr)
#pheno = "ilamax"

args = commandArgs(trailingOnly=TRUE)
pheno = args[1]
print(paste("running",pheno, "..."))
load("data/phenotypeData.rda", verbose = T)

# ----------------------------------
#
# covariates
#

phenoTabIncl = phenoTab[ind.indiv,]

# base
f <- as.formula(paste(pheno, "age + sex", sep = "~"))
summary(mod.base <- lm(f, data = phenoTabIncl[ind.train,]))
pred.base <- predict(mod.base, phenoTabIncl)

qcTab = data.frame(qcTab, stringsAsFactors = F)
rownames(qcTab) <- as.character(qcTab$sample.id)

# pc's
PC = as.matrix(qcTab[as.character(phenoTabIncl$IID), paste0("PC",1:10)])


# outcome
y <- phenoTabIncl[,pheno]

# ----------------------------------
#
# load genotypes
#

ukb <- snp_attach("data/UKB_imp_lacmr.rds")
G <- ukb$genotypes
CHR <- as.numeric(ukb$map$chromosome)
POS <- ukb$map$physical.pos
dim(G) # 33911 652255 
file.size(G$backingfile) / 1024^3  # 21 GB


# ----------------------------------
#
# run
#

system.time(
    mod <- big_spLinReg(G,
                        y[ind.train],
                        ind.train,
                        covar.train = PC[ind.train, ],
                        base.train = pred.base[ind.train],
                        dfmax = Inf,
                        alphas = c(1, 0.5, 0.1, 0.01, 0.0001),
                        K = 8,
                        eps = 1e-7,
                        ncores = 10)
) 



# ----------------------------------
#
# pred
#

## pred <- pred.base[ind.test] + predict(mod,
##                                       G,
##                                       ind.test,
##                                       covar.row = PC[ind.test, ]
##                                       )


# ----------------------------------
#
# save
#

mod.fn = paste0('results/', pheno, ".rda")
save(mod, pred.base, file = mod.fn)


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
