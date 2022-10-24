#prev fit

vars <- dplyr::mutate(dplyr::rename(data.table::fread(cmd=paste0(configs[['zstdcat.path']], ' ', paste0(genotype.pfile, '.pvar.zst'))), 'CHROM'='#CHROM'), VAR_ID=paste(ID, ALT, sep='_'))$VAR_ID

beta = fitSnpnet$beta[[which.max(fitSnpnet$metric.val)]]
varsID = names(beta)
idxVars = na.omit(match(varsID, vars))


# --------------------------------------------------
# fit

library(glmnet)

covariates

ids <- readIDsFromPsam(paste0(genotype.pfile, '.psam'))
phe <- readPheMaster(phenotype.file, ids, "gaussian", covariates, phenotype, NULL, NULL, configs)


pvar <- pgenlibr::NewPvar(paste0(genotype.pfile, '.pvar.zst'))
pgen <- pgenlibr::NewPgen(paste0(genotype.pfile, '.pgen'), pvar = pvar, sample_subset = NULL)

data.X <- pgenlibr::ReadList(pgen, idxVars, meanimpute=F)
colnames(data.X) <- varsID[-c(1:12)]
p <- ncol(data.X)
pnas <- numeric(p)

for (j in 1:p) {
    pnas[j] <- mean(is.na(data.X[, j]))
    data.X[is.na(data.X[, j]), j] <- mean(data.X[, j], na.rm = T) # mean imputation
}

data.X <- as.matrix(cbind(age = phe$age,
                          sex = phe$sex,
#                          bsa = phe$bsa,
                          phe[, paste("PC", 1:10, sep = "")], data.X))

data.y <- phe$ilamax
pfactor <- rep(1, p + 12)
pfactor[1:12] <- 0 # we don't penalize the covariates

#fit_glmnet <- glmnet::glmnet(data.X, data.y, penalty.factor = pfactor, standardize = F)

cvfit =glmnet::cv.glmnet(data.X,
                         data.y,
                         keep=TRUE,
                         type.measure = "mse",
                         standardize = F)

coef(cvfit)

# --------------------------------------------------
# predict


s = which(cvfit$lambda == cvfit$lambda.1se)
betas = as.matrix(cvfit$glmnet.fit$beta[,s])
nzeroSnps = rownames(betas)[betas != 0]
data.X[,nzeroSnps]

fit_glmnet <- glmnet::glmnet(data.X[,nzeroSnps],
                             data.y,
                             lambda = cvfit$lambda.1se,
                             standardize = F)

new_genotype_file = "data/ukbMriSubset.test"
new_phenotype_file = "data/phenTest.sort.phe"

ids <- readIDsFromPsam(paste0(new_genotype_file, '.psam'))
phe <- readPheMaster(new_phenotype_file, ids, "gaussian", c(covariates,"af","lamax"), phenotype, NULL, NULL, configs)
pvar <- pgenlibr::NewPvar(paste0(new_genotype_file, '.pvar.zst'))
pgen <- pgenlibr::NewPgen(paste0(new_genotype_file, '.pgen'), pvar = pvar, sample_subset = NULL)

data.X <- pgenlibr::ReadList(pgen, idxVars, meanimpute=F)


colnames(data.X) <- varsID[-c(1:12)]
p <- ncol(data.X)
pnas <- numeric(p)

for (j in 1:p) {
    pnas[j] <- mean(is.na(data.X[, j]))
    data.X[is.na(data.X[, j]), j] <- mean(data.X[, j], na.rm = T) # mean imputation
}


data.X <- as.matrix(cbind(age = phe$age, sex = phe$sex, phe[, paste("PC", 1:10, sep = "")], data.X))

data.X = data.X[,nzeroSnps]

testing = predict(fit_glmnet, newx = data.X, s = fit_glmnet$lambda)
cor(testing, phe$ilamax)
summary(lm(phe$ilamax ~ testing ))

beta = as.matrix(fit_glmnet$beta)
prs = scale(data.X[,-c(1:12)] `%*% beta[-c(1:12)])

summary(lm(phe$ilamax ~ prs ))
summary(lm(phe$ilamax ~  phe$sex + phe$age + prs ))
summary(lm(phe$ilamax ~ testing ))


summary(glm(phe$af ~ phe$age + phe$sex + scale(phe$lamax), family = binomial))
summary(glm(phe$af ~ phe$age + phe$sex + prs, family = binomial))

mean(abs(phe$ilamax - testing))


mean((phe$ilamax - testing)^2)


tss = sum((phe$lamin - mean(phe$lamin))^2)
rss = sum((phe$lamin - testing)^2)
rsq = 1 - (rss/tss)
