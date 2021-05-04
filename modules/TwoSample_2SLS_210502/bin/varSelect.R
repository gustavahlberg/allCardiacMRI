# ---------------------------------------------
#
# Variable selection for predicting LA volume&function
#
# ---------------------------------------------
#
# data
#


phenoTab <- read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                      stringsAsFactors = F,
                      header = T)


load(file = "dataFrame_210503.rda")


testSet <- rownames(df[!df$sample.id %in% phenoTab$IID, ])
trainingSet <- rownames(df[(df$sample.id %in% phenoTab$IID ), ])


library(rstanarm)
options(mc.cores = parallel::detectCores())
library(loo)
library(projpred)
library(bayesplot)

SEED = 87

set.seed(SEED)

length(trainingSet)

dfVar <- data.frame(ilamax = df[trainingSet,]$ilamax,
                    ilamin = df[trainingSet,]$ilamin,
                    laaef = df[trainingSet,]$laaef,
                    lapef = df[trainingSet,]$lapef,
                    latef = df[trainingSet,]$latef,
                    age = df[trainingSet,]$age,
                    sex = df[trainingSet,]$sex,
                    af = df[trainingSet,]$AF,
                    t2d = df[trainingSet,]$T2D,
                    bmi = df[trainingSet,]$bmi,
                    height = df[trainingSet,]$height,
                    sbp = df[trainingSet,]$SBP_adj10mmhg,
                    hr = df[trainingSet,]$HR)


dfVar <- dfVar[-which(is.na(dfVar$sbp)),]

idx <- sample(x = 1:nrow(dfVar), size = 6000, replace = F) 
dfVarSample <- dfVar[idx,]


#save(dfVarSample, dfVar, file = "dfVar.rda")

#any(is.na(dfVar))
#summary(dfVar)

# ---------------------------------------------
#
# null model
#


# fitg0 <- stan_glm(y ~ 1, data = dfVarSample, 
#                   na.action = na.fail, 
#                   family=gaussian(),
#                   seed=SEED)


# ---------------------------------------------
#
# regress
#
# fitg <- stan_glm(y ~ x1 + x2 + x3 + x4, data = df, na.action = na.fail, family=poisson(), QR=TRUE, seed=SEED)

phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")

for(pheno in phenos) {

    # 1
    pheno <- phenos[1]
    y <- dfVarSample[, pheno]

    fitg <- stan_glm(y ~ age + sex + af + t2d + bmi + height + sbp + hr,
                     data = dfVarSample, 
                     na.action = na.fail, 
                     family = gaussian(), 
                     QR=TRUE,
                     iter = 4000,
                     seed=SEED)



#mcmc_areas(as.matrix(fitg),prob_outer = .99)
#mcmc_pairs(as.matrix(fitg),pars = c("age","sex","af","bmi"))



# ---------------------------------------------
#
# projective predictive variable selection using the previous full model. 
# A fast leave-one-out cross-validation approach (Vehtari, Gelman and Gabry, 2017) 
# is used to choose the model size.
#

    ref <- get_refmodel(fitg)
    fitg_cv <- cv_varsel(ref, method='forward', cv_method='LOO')


    models.fn = paste0("fit_", pheno, ".rda")
    save(fitg_cv, fitg, save = models.fn)



plot(fitg_cv, stats = c('elpd', 'rmse'))




solution_terms(fitg_cv) 
(nv <- suggest_size(fitg_cv, alpha=0.1))

projg <- project(fitg_cv, nv = nv, ns = 4000)
round(colMeans(as.matrix(projg)),1)

round(posterior_interval(as.matrix(projg)),1)



mcmc_areas(as.matrix(projg), pars = solution_terms(fitg_cv)[1:4])
mcmc_areas(as.matrix(projg), 
           pars = c('(Intercept)', names(solution_terms(fitg_cv)[1:2])))




