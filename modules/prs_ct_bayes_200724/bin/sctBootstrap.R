# ----------------------------------
#
# 6)  C + T bootstrap
#
# ---------------------------------
#
# load
#

#pheno = 'ilamax'

library(parallel)
library(tidyverse)
library(bigsnpr)
load("data/sampleData.rda", verbose = T)
load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)


bootstrapResults.fn = sprintf("results/bootstraped_CTPrs_%s.rds",pheno)

matdata = paste0("data/",pheno,".rds")
phenoTabIncl = phenoTab[ind.indiv,]

ukbb <- snp_attach(matdata)
G <- ukbb$genotypes

CHR <- as.integer(ukbb$map$chromosome)
POS <- ukbb$map$physical.pos
rs <- ukbb$map$rsid


all(regGwas$snp == rs)
lpval <- -log10(regGwas$p)
y = phenoTabIncl[,pheno]

# shift beta's
beta = -1*regGwas$beta

grid.lps = seq(from= -log10(1e-2), to = -log10(5e-08), by = exp(log(0.2))) 

# ---------------------------------
#
# clump
#


print("running clumping")
all_keep <- snp_grid_clumping(
    G, CHR, POS, lpS = lpval, ind.row = ind.train,
    grid.thr.r2 = c(0.1, 0.2, 0.5, 0.8),
    grid.base.size = c(50, 200, 500, 1000),
    ncores = 6)
print("completed clumping")

# ---------------------------------
#
# sex + age betas
#

#f <- as.formula(paste(pheno, " ~ age + sex +", paste0(" PC",1:10, collapse="+")))
#f <- as.formula(paste(pheno, " ~ age + sex"))
#summary(mod.base <- lm(f, data = phenoTabIncl[ind.train,]))
#covars = coef(mod.base)[-1]

# ---------------------------------
#
# C+T bootstrap
#

set.seed(1234)
bsResList <- list()
S = 1000

bsResList <- mclapply(seq(S), function(j) {
    print(paste("iter:", j))
    ind.boot = sample(ind.test, size = length(ind.test), replace = T)
                                        #pred.base = predict(mod.base, phenoTabIncl[ind.boot,])
    
    grid2 <- attr(all_keep, "grid") %>%
    mutate(thr.lp = list(grid.lps), num = row_number()) %>%
    unnest()
    s <- nrow(grid2)

    res = lapply(1:dim(grid2)[1], function(i) {
        max_prs <- grid2[i,]
        ind.keep <- unlist(map(all_keep, max_prs$num))
        pred_max_prs <- snp_PRS(G, beta[ind.keep],
                                ind.test = ind.boot,
                                ind.keep = ind.keep,
                                lpS.keep = lpval[ind.keep],
                                thr.list = max_prs$thr.lp)

        mod <- lm(y[ind.boot] ~ age + sex + pred_max_prs, data = phenoTabIncl[ind.boot,])
        df = data.frame(age = phenoTabIncl[ind.boot,]$age,
                        sex = phenoTabIncl[ind.boot,]$sex,
                        pred_max_prs = pred_max_prs)
        yhat = predict(mod, df)
        c(mse = mean((yhat - y[ind.boot])^2),
          cor = cor(pred_max_prs, y[ind.boot])
          )
    })

    gridRes = cbind(grid2, (do.call(rbind, res)))
    gridRes$iter = j
    return(gridRes)
}, mc.cores = 7)


save(bsResList, file = bootstrapResults.fn)


## tmp = lapply(bsResList, function(x) {
##     split(x, x[,c('size', 'thr.r2')])
## })
## tmp = do.call(rbind,bsResList)
## tmp2 = split(tmp, tmp[,c('size', 'thr.r2')])

###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################


## gridRes = cbind(grid2, (do.call(rbind, res)))
## head(gridRes[order(gridRes$cor, decreasing = T),], 20)
## cor(gridRes$cor, gridRes$mse)


## max_prs <- gridRes[which.max(gridRes$cor),]
## max_prs <- gridRes[which.min(gridRes$mse),]

## ind.keep <- unlist(map(all_keep, max_prs$num))
## ind <- ind.keep[which(lpval[ind.keep] > max_prs$thr.lp)]


## #ind.keep <- unlist(map(all_keep, 10))

## pred_max_prs <- snp_PRS(G, beta[ind.keep],
##                         ind.keep = ind.keep,
##                         lpS.keep = lpval[ind.keep],
##                         thr.list = max_prs$thr.lp)

## print(cor(pred_max_prs[ind.test], y[ind.test]))
## summary(lm(y[ind.test] ~ pred_max_prs[ind.test] + age +  sex, data = phenoTabIncl[ind.test,]))

