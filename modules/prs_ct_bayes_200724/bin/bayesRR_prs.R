# ----------------------------------
#
# 4) bayes C + T w/ RR
#
# ---------------------------------
#
# load
#

#pheno = 'ilamax'

library(bigsnpr)
load("data/sampleData.rda", verbose = T)
load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)
library("rstan")
library("rstanarm")

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



# ---------------------------------
#
# clump
#

all_keep <- snp_grid_clumping(
    G, CHR, POS, lpS = lpval, ind.row = ind.train,
    grid.thr.r2 = c(0.2, 0.4, 0.6 ,0.8),
    grid.base.size = c(250),
    ncores = 4
) 

# ---------------------------------
#
# group
#


grid.lps = seq(from= -log10(1e-3), to = -log10(5e-08), by = exp(log(1)))

#r2vec = c("r2_0.2","r2_0.5","r2_0.8")

r2vec = c("r2_0.2","r2_0.4", "r2_0.6","r2_0.8")
r2snp = list()
list_pvalR2 = list()
for(i in 1:4) {
    r2snp[[i]] = unlist(sapply(all_keep, function(x) x[[i]]))
    list_pvalR2[[r2vec[i] ]] = list()
    for(lps.thres  in grid.lps) {
        idxLps = which(lpval >= lps.thres)
        print(length(which(r2snp[[i]] %in% idxLps)))
        pname = paste0("lp_",round(lps.thres,2))
        list_pvalR2[[r2vec[i] ]][[pname]]  = r2snp[[i]][which(r2snp[[i]] %in% idxLps)]
    }
}


# ---------------------------------
#
# data
#


idxSnps = unique(unlist(list_pvalR2))
Gmat = G[,idxSnps]
colnames(Gmat) = rs[idxSnps]

df = data.frame(age = phenoTabIncl$age,sex = phenoTabIncl$sex,
                phenoTabIncl[,paste0('PC',c(1:10))],
                Gmat
           )

rsMut = gsub("(^\\d+):","X\\1.", rs)


# ---------------------------------
#
# regression 
#

# init
models <- list()
S = 15000
# priors R2
h2s = c(0.27, 0.3, 0.22, 0.22, 0.21)
names(h2s) <- c("ilamin", "ilamax", "laaef", "lapef", "latef")


#2 x for loop
for(i in 1:length(list_pvalR2)) {
    for(j in 1:length(list_pvalR2[[i]])) {

        modname = paste(names(list_pvalR2[i]), names(list_pvalR2[[i]])[j], sep = "_")
        rsInModel = rsMut[ list_pvalR2[[i]][[j]] ]
        variables = c(colnames(df)[1:12], rsInModel)

        x = length(rsInModel)
        p  =  1*log(x)/(1+log(x))
        r2prior = h2s[pheno]*0.7*p

        print(paste("running:", modname, "with R2 prior:", r2prior))

        fit_mod <- stan_lm(y[ind.train] ~ .,
                           prior = R2(r2prior, what = 'mean'),
                           #prior_intercept = normal(mean(y[ind.train]),),
                           iter = S,
                           chains = 4,
                           cores = 4,
                           data = df[ind.train, variables])

        models[[modname]] <- fit_mod
    }
} #end for loop


looList = lapply(models, loo)


results.fn = sprintf("results/bayesPrs_%s.rds",pheno)
save(models, looList, file = results.fn)


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################

## loo_compare(looList)
## wgt = loo_model_weights(looList)

## S = ....
## wgt = wgt[which(wgt > 0.01)]
## wgt = wgt/sum(wgt)
## yRep = list()

## for(i in 1:length(wgt)) {
##     modname = names(wgt)[i]
##     mod = models[[modname]]
##     variables = names(coef(mod)[-1])
##     yRep[[modname]] = posterior_predict(mod, newdata = df[ind.test, variables], draws = wgt[i]*S)
##     print(cor(y[ind.test], colMeans(yRep[[modname]])))
## }

#yTest = posterior_predict(fit_mod, newdata = df[ind.test,])
#cor(y[ind.test], colMeans(yTest))
#summary(lm(y[ind.test] ~ colMeans(yTest) ))

## loo_compare(looList)
## wgt = loo_model_weights(looList)
## yMeanMod = do.call(rbind, yRep)
## dim(yMeanMod)
## print(cor(y[ind.test], colMeans(yMeanMod))^2)
## summary(lm(y[ind.test] ~ colMeans(yMeanMod) ))



## i = 1; j = 3
## rsInModel = rsMut[ list_pvalR2[[i]][[j]] ]
## variables = c(colnames(df)[1:12], rsInModel)
## modname = paste(names(list_pvalR2[i]), names(list_pvalR2[[i]])[j], sep = "_")


## tmp = t(extract(models[[modname]]$stanfit)$beta[,1,])
## prs1 = as.matrix(df[ind.test,variables]) %*% tmp
## prs1p = rowMeans(prs1)

## #prs2p = prs1p
## #prs = as.matrix(df[ind.test, variables]) %*% coef(models[[modname]])[-1]

## cor(y[ind.test], prs2p)

## #prs2 = prs

## cor(prs2p, prs1p)

