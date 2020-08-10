# ----------------------------------
#
# 5) predict bayes C + T w/ RR
#
# ---------------------------------
#
# load
#

pheno = 'ilamax'

library(bigsnpr)
load("data/sampleData.rda", verbose = T)
load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)
library("rstan")
library("rstanarm")
load(sprintf("results/bayesPrs_%s.rds",pheno), verbose = T)

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
# weights
#

if(file.exists(sprintf("results/ModelWeights_%s.rds",pheno))) {
    load(sprintf("results/ModelWeights_%s.rds",pheno))
} else {
    loo_compare(looList)
    wgt = loo_model_weights(looList)
    wgt = wgt[which(wgt > 0.01)]
    save(wgt, file = sprintf("results/ModelWeights_%s.rds",pheno))
}

    
wgt = wgt/sum(wgt)
models <- models[names(wgt)]





# ---------------------------------
#
# data
#

rsMut = gsub("(^\\d+):","X\\1.", rs)
coefficients = unique(unlist((sapply(1:length(models), function(i) names(coef(models[[i]]))))))
snpVars = coefficients[-c(1:13)]
idxSnps = which(rsMut %in% snpVars)

rsMutVar = rsMut[idxSnps]

# rm duplicated
if(any(duplicated(rsMutVar))) {
    idxDupS = which(duplicated(rsMutVar))
    for(idxDup in idxDupS){
        rsdup = rsMutVar[idxDup]
        idxDup2 = which(rsMut == rsdup)
        idxkeep = which.min(regGwas[idxDup2,]$p)
        idxSnps = idxSnps[-which(idxSnps %in% idxDup2[-idxkeep])]
    }
    rsMutVar = rsMut[idxSnps]
}

# ----------------   

Gmat = G[,idxSnps]
colnames(Gmat) = rsMut[idxSnps]

df = data.frame(age = phenoTabIncl$age,sex = phenoTabIncl$sex,
                phenoTabIncl[,paste0('PC',c(1:10))],
                Gmat
           )

rm(Gmat)

# ---------------------------------
#
# save betas for weighted average model
#

S = 30000
modAW = list()

for(i in 1:length(wgt)) {
    
    modname = names(wgt)[i]
    mod = models[[modname]]
    idxDraws = sample(S, size = floor(S*wgt[modname]), replace = F)
    beta = extract(mod$stanfit)$beta[,1,][idxDraws,]
    colnames(beta) <- names(coef(mod))[-1]
    alpha = extract(mod$stanfit)$alpha[idxDraws,]
    R2 = extract(mod$stanfit)$R2[idxDraws,]
    sigma = extract(mod$stanfit)$sigma[idxDraws,]

    modAW[[modname]] = list(beta = beta, alpha = alpha , sigma = sigma , R2 = R2)

}

# save
parameters.fn = sprintf("results/bayesParameters_%s.rds",pheno)
save(modAW, file = parameters.fn)
rm(modAW)

# ---------------------------------
#
# predict
#

yRep = list()
S = 10000

for(i in 1:length(wgt)) {
    modname = names(wgt)[i]
    mod = models[[modname]]
    variables = names(coef(mod)[-1])
    yRep[[modname]] = posterior_predict(mod, newdata = df[, variables], draws = wgt[i]*S)
}


parameters.fn = sprintf("results/bayesPosteriorPredictions_%s.rds",pheno)
save(yRep, file = parameters.fn)
rm(yRep)

#yMeanMod = do.call(rbind, yRep)
#print(cor(y[ind.test], colMeans(yMeanMod[,ind.test])))
#summary(lm(y[ind.test] ~ colMeans(yMeanMod[,ind.test])))


## # ---------------------------------
## #
## # save
## #




## loo_R2 <- function(fit) {
##     y <- get_y(fit)
##     ypred <- posterior_linpred(fit, transform = TRUE)
##     ll <- log_lik(fit)
##     M <- length(fit$stanfit@sim$n_save)
##     N <- fit$stanfit@sim$n_save[[1]]
##     r_eff <- relative_eff(exp(ll), chain_id = rep(1:M, each = N))
##     psis_object <- psis(log_ratios = -ll, r_eff = r_eff)
##     ypredloo <- E_loo(ypred, psis_object, log_ratios = -ll)$value
##     eloo <- ypredloo-y
##     n <- length(y)
##     rd<-rudirichlet(4000, n)
##     vary <- (rowSums(sweep(rd, 2, y^2, FUN = "*")) -
##              rowSums(sweep(rd, 2, y, FUN = "*"))^2)*(n/(n-1))
##     vareloo <- (rowSums(sweep(rd, 2, eloo^2, FUN = "*")) -
##                 rowSums(sweep(rd, 2, eloo, FUN = "*")^2))*(n/(n-1))
##     looR2 <- 1-vareloo/vary
##     looR2[looR2 < -1] <- -1
##     looR2[looR2 > 1] <- 1
##     return(looR2)
## }


## fit = models[['r2_0.4_lp_6']]

## fit$stanfit@sim


## loo_R2(fit)
