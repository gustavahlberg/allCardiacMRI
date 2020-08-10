# ----------------------------------
#
# 4) bayes C + T 
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
    grid.thr.r2 = c(0.2, 0.5, 0.8),
    grid.base.size = c(250),
    ncores = 6
) 



######################################
#
# new index


#ind.train = sample(ind.test, length(ind.test)/2)
#ind.test = setdiff(ind.test, ind.train)



# ---------------------------------
#
# group
#


grid.lps = seq(from= -log10(5e-4), to = -log10(5e-08), by = exp(log(1)))

r2vec = c("r2_0.2","r2_0.5","r2_0.8")
r2snp = list()
list_pvalR2 = list()
for(i in 1:3) {
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

head(gsub(":",".", rs), 30)
rsMut = gsub("(^\\d+):","X\\1.", rs)

# ---------------------------------
#
# regression 
#


models <- list()
models2 <- list()

i = 1; j = 3
modname = paste(names(list_pvalR2[i]), names(list_pvalR2[[i]])[j], sep = "_")
rsInModel = rsMut[ list_pvalR2[[i]][[j]] ]
variables = c(colnames(df)[1:12], rsInModel)

y = scale(phenoTabIncl[,pheno])
p0 <- ifelse(ncol(df) < 50, 10, floor(ncol(df)/4))
n <- nrow(df)
D <- ncol(df)
tau0 <- p0/(D - p0) * 1/sqrt(n)

fit_mod <- 
    stan_glm(y[ind.train] ~ . ,
             family = gaussian(), 
             prior = hs(df = 1, 
                        global_df = 1,
                        global_scale = tau0, 
                        slab_scale = 2.5 * sd(y)),
             iter = 3000,
             adapt_delta = 0.9999,
             data = df[ind.train, variables]
             )

fit_mod2 <- stan_glm(y[ind.train] ~ .,
                    family = gaussian(), 
                    prior = lasso(df = 1, location = 0, scale = 10,
                                  autoscale = TRUE),
                    prior_intercept = normal(location = 0, scale = 10),
                    prior_aux = exponential(rate = 1, autoscale = TRUE),
                    iter = 3000,
                    data = df[ind.train, variables])


fit_mod <- stan_lm(y[ind.train] ~ .,
                    prior = R2(0.1, what = 'mean'),
                    prior_intercept = normal(location = 0, scale = 10),
                    iter = 3000,
                    data = df[ind.train, variables])




modname = paste(names(list_pvalR2[i]), names(list_pvalR2[[i]])[j], sep = "_")
#models[[modname]] <- fit_mod
models2[[modname]] <- fit_mod2


looList = lapply(models2, loo)
loo_compare(looList)

loo_post <- loo(fit_mod)
loo_post2 <- loo(fit_mod2)

loo_compare(list(loo_post, loo_post2))
loo_model_weights(list(loo_post, loo_post2))

wgt = loo_model_weights(looList)
S = 5000

#y_rep1 <- posterior_predict(fit_mod, newdata = df)
i=2

idx = which(rs %in% gsub("\\.",":",gsub("^X","",names(coef(models2[[i]]))[-1])))
Gmat = G[,idx]
colnames(Gmat) = rs[idx]

df = data.frame(age = phenoTabIncl$age,sex = phenoTabIncl$sex,
                phenoTabIncl[,paste0('PC',c(1:10))],Gmat)

y_rep2 <- posterior_predict(models2[[i]], newdata = df, draws = wgt[i]*S)

y_rep2 <- posterior_predict(fit_mod2, newdata = df[,variables],draws = wgt[2]*S )
y_rep3 <- rbind(y_rep1, y_rep2)

y_rep1 <- posterior_predict(fit_mod, newdata = df, draws = S)
y_rep2 <- posterior_predict(fit_mod2, newdata = df[,variables], draws = S)

cor(y[ind.test], colMeans(y_rep3[,ind.test]))
cor(y[ind.test], colMeans(y_rep2[,ind.test]))
cor(y[ind.test], colMeans(y_rep1[,ind.test]))

cor(colMeans(y_rep2[,ind.test]), colMeans(y_rep1[,ind.test]))


cor(y[ind.train], colMeans(y_rep3[,ind.train]))
cor(y[ind.train], colMeans(y_rep2[,ind.train]))
cor(y[ind.train], colMeans(y_rep1[,ind.train]))


y_hat <- predict(fit_mod2, newdata = df[ind.test,])
cor(colMeans(y_rep3[,ind.test]), y_hat)

cor(y_hat, y[ind.test])
cor(colMeans(y_rep1[,ind.test]), y[ind.test])


draws <- as.data.frame(fit_mod)
#test = cbind(1,as.matrix(df[ind.test,])) %*% t(as.matrix(draws[,-c(178)]))


prs1 = as.matrix(df[ind.test,-c(1:12)]) %*% t(as.matrix(draws[,-c(1:13,178)]))
prs2 = as.matrix(df[ind.test,]) %*% t(as.matrix(draws[,-c(1,178)]))

prs1 = as.matrix(df[ind.test,variables]) %*% t(extract(fit_mod$stanfit)$beta[,1,])
prs2 = as.matrix(df[ind.test,variables[-c(1:12)]]) %*% t(extract(fit_mod$stanfit)$beta[,1,-c(1:12)])


cor(apply(prs1,1,median), y_hat)
cor(apply(prs1,1,mean), y_hat)
cor(apply(prs2,1,mean), y_hat)

cor(apply(prs1,1,mean), colMeans(y_rep2[,ind.test]))
cor(apply(prs2,1,mean), colMeans(y_rep2[,ind.test]))

cor(apply(prs2,1,median), y[ind.test])
cor(apply(prs2,1,mean), y[ind.test])
cor(apply(prs1,1,mean), y[ind.test])


prs =  as.matrix(df[ind.test,variables[-c(1:12)]]) %*% coef(fit_mod)[-c(1:13)]

prs1p = rowMeans(prs1)
prs2p = rowMeans(prs2)

cor(prs1p, prs)
cor(prs2p, prs)


cor(y[ind.test], colMeans(y_rep2)[ind.test])
cor(y[ind.test], colMeans(y_rep1)[ind.test])
cor(y[ind.test], prs)
cor(y[ind.test], prs1p)


summary(lm(y[ind.test] ~ colMeans(y_rep3[,ind.test]) ))
summary(lm(y[ind.test] ~ colMeans(y_rep1[,ind.test]) ))
summary(lm(y[ind.test] ~ colMeans(y_rep2[,ind.test]) ))

summary(lm(y[ind.test] ~ prs1p ))
summary(lm(y[ind.test] ~ prs2p ))


cor(y[ind.test], prs1p)^2
cor(y[ind.test], prs2p)
cor(y[ind.test], prs1p)
cor(y[ind.test], prs)


summary(glm(phenoTabIncl[ind.test,]$af ~ scale(prs1p),
        family = binomial))

summary(glm(phenoTabIncl[ind.test,]$af ~ scale(prs2p),
        family = binomial))
#cbind(Median = coef(fit_mod2), MAD_SD = se(fit_mod2))



load("data/dfStroke.rda")
matdata = paste0("data/stroke_prs_laaef.rds")
ukbb <- snp_attach(matdata)
Gstroke <- ukbb$genotypes

Gs = Gstroke[,idxSnps]
colnames(Gs) = rs[idxSnps]

prs1 = as.matrix(Gs) %*% t(as.matrix(draws[,-c(1:13,200)]))
prs = scale(rowMeans(prs1))

y = ifelse(dfStroke$IschStroke == -9999, 0, 1) 

a2 = dfStroke$ageAtIschStroke
a2[is.na(a2)] <- dfStroke$age[is.na(a2)]


summary(glm(y ~ prs + a2 + sex, data = dfStroke, family = binomial))


