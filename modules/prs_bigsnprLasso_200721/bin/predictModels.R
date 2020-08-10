library(dplyr)
library(bigsnpr)
load("data/phenotypeData.rda", verbose = T)
phenoTabIncl = phenoTab[ind.indiv,]


load("results/height.rda", verbose = T)






# ----------------------------------
#
# load genotypes & covars
#


ukb <- snp_attach("data/UKB_imp_lacmr.rds")
G <- ukb$genotypes
CHR <- as.numeric(ukb$map$chromosome)
POS <- ukb$map$physical.pos
dim(G) # 33911 652255 
file.size(G$backingfile) / 1024^3  # 21 GB

qcTab = data.frame(qcTab, stringsAsFactors = F)
rownames(qcTab) <- as.character(qcTab$sample.id)
# pc's
PC = as.matrix(qcTab[as.character(phenoTabIncl$IID), paste0("PC",1:10)])


# ----------------------------------
#
# refit w/ glmnet 
#

y = phenoTabIncl$height

lambda = mean(sapply(mod[[5]], function(x) x[['lambda']][which.min(x[['loss.val']])]))
beta = summary(mod[2])$beta[[1]]
# rm PC beta
beta = beta[-c((length(beta)-9):length(beta))]
betaidx = which(beta != 0)
Gmat = G[,betaidx]
colnames(Gmat) = ukb$map$rsid[betaidx]

data.X <- as.matrix(cbind(age = phenoTabIncl$age,
                          sex = phenoTabIncl$sex,
                          phenoTabIncl[, paste("PC", 1:10, sep = "")],
                          Gmat))

pfactor <- rep(1, ncol(data.X))
pfactor[1:2] <- 0 # we don't penalize the covariates


fitGlmnet <- glmnet::glmnet(data.X[ind.train,],
                            y[ind.train],
                            lambda = lambda,
                            standardize = F,
                            alpha = 0.01,
                            penalty.factor = pfactor)


testing = predict(fitGlmnet, newx = data.X[ind.test,])
cor(testing[,1], y[ind.test])


beta = as.matrix(fitGlmnet$beta)
prs2 = scale(data.X[,-c(1:12)] %*% beta[-c(1:12)])

cor(prs[ind.test,], testing)

summary(lm(y[ind.test] ~ testing))
summary(lm(y[ind.test] ~ prs[ind.test]))


betaMean = summary(mod[2])$beta[[1]]


prs = snp_PRS(G,
              betaMean[-c((length(betaMean) - 9):length(betaMean))],
              ind.test = rows_along(G),
              ind.keep = cols_along(G),
              #same.keep = rep(TRUE, length(ind.keep)),
              lpS.keep = NULL,
              thr.list = 0
)

cor(prs,prs2)

pred <- predict(mod[2], G, ind.test, base.row = pred.base[ind.test] ,covar.row = PC[ind.test, ])
#save(pred,prs, prs2, file = "pred.rda")

cor(y[ind.test], pred)
cor(y[ind.test], pred.base[ind.test] + prs[ind.test])
cor(y[ind.test], prs[ind.test])
cor(y[ind.test], pred.base[ind.test])


summary(lm(y[ind.test] ~ pred))
summary(lm(y[ind.test] ~ prs[ind.test]))
summary(lm(y[ind.test] ~ pred.base[ind.test]))
summary(lm(y[ind.test] ~ pred.base[ind.test] + prs2[ind.test]))
summary(lm(y[ind.test] ~ pred.base[ind.test] + prs[ind.test]))
summary(lm(y[ind.test] ~ pred.base[ind.test] + prs[ind.test] + prs2[ind.test]))


summary(glm(phenoTabIncl[ind.test,]$af ~ scale(pred), family = binomial))
summary(glm(phenoTabIncl[ind.test,]$af ~ pred.base[ind.test], family = binomial))
summary(glm(phenoTabIncl[ind.test,]$af ~ prs[ind.test], family = binomial))

summary(glm(phenoTabIncl[ind.test,]$af ~ scale(phenoTabIncl$ilamin[ind.test]), family = binomial))


summary(glm(phenoTabIncl$af ~ scale(phenoTabIncl$lapef) + phenoTabIncl$sex +
          phenoTabIncl$age, family = binomial))

hiprs = ifelse(prs[ind.test] > 2, 1,0)

summary(glm(phenoTabIncl[ind.test,]$af ~ hiprs[ind.test]  +
           phenoTabIncl$sex[ind.test] + phenoTabIncl$age[ind.test],
           family=gaussian))

summary(lm(phenoTabIncl[ind.test,]$ilamin ~ prs[ind.test]  +
           phenoTabIncl$sex[ind.test] + phenoTabIncl$age[ind.test]))



summary(glm(phenoTabIncl$af ~ prs + 
            phenoTabIncl$sex + phenoTabIncl$age,
            family = binomial))
