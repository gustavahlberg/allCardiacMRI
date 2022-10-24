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


#testSet <- rownames(df[!df$sample.id %in% phenoTab$IID, ])
sampleSet <- rownames(df[(df$sample.id %in% phenoTab$IID ), ])

rownames(phenoTab) <- as.character(phenoTab$IID)

SEED = 1234
set.seed(SEED)
length(sampleSet)

dfVar <- data.frame(ilamax = df[sampleSet,]$ilamax,
                    ilamin = df[sampleSet,]$ilamin,
                    laaef = df[sampleSet,]$laaef,
                    lapef = df[sampleSet,]$lapef,
                    latef = df[sampleSet,]$latef,
                    age = scale(df[sampleSet,]$age),
                    sex = df[sampleSet,]$sex,
                    af = df[sampleSet,]$AF,
                    hf = df[sampleSet,]$hf_cm,
                    t2d = df[sampleSet,]$T2D,
                    bmi = scale(df[sampleSet,]$bmi),
                    height = scale(df[sampleSet,]$height),
                    sbp = scale(df[sampleSet,]$SBP_adj10mmhg),
                    hr = scale(df[sampleSet,]$HR))

rownames(dfVar) <- rownames(df[sampleSet,])
dfVar <- dfVar[-which(is.na(dfVar$sbp)),]

idxTrain <- sample(x = 1:nrow(dfVar), 
                   size = floor(nrow(dfVar)*0.7), 
                   replace = F) 

dfVarTrain <- dfVar[idxTrain,]
dfVarTest <- dfVar[-idxTrain,]


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
# skeleton
#

phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")
res <- matrix(data = NA, nrow = 10, ncol = 10)
rownames(res) <- c("MSE", "age","sex", "af","hf","t2d","bmi", "height", "sbp","hr")

tmp <- c()

for(i in 1:5){
  tmp <- c(tmp,paste0(phenos[i], c(" 1se lambda", " min lambda")))
}

colnames(res) <- tmp


# ---------------------------------------------
#
# regress
#
# fitg <- stan_glm(y ~ x1 + x2 + x3 + x4, data = df, na.action = na.fail, family=poisson(), QR=TRUE, seed=SEED)

phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")

for(pheno in phenos) {

  # 1
  #pheno <- phenos[3]

  y <- dfVarTrain[, pheno]
  x <- as.matrix(dfVarTrain[, c("age","sex", "af","hf","t2d","bmi", "height", "sbp","hr")])
  cvfit <- cv.glmnet(x, y, 
                     alpha = 1, 
                     family = "gaussian", 
                     type.measure = "mse",
                     standardize = T)
  
  png(paste0(pheno,"_glmnet_mse.png"),
      width=6,height=6,res=300,units="in")
  
  plot(cvfit)
  
  dev.off()
  
  L_se1 <- as.matrix(coef(cvfit, s = "lambda.1se"))
  L_min <-coef(cvfit, s = "lambda.min")
  
  # predict
  y <- dfVarTest[, pheno]
  x <- as.matrix(dfVarTest[, c("age","sex", "af","hf","t2d","bmi", "height", "sbp","hr")])
  yhat1se <- predict(cvfit, newx = x, s = "lambda.1se")
  yhatmin <- predict(cvfit, newx = x, s = "lambda.min")
  mse_1se <- sum((y - yhat1se)^2)/length(yhat1se)
  mse_min <- sum((y - yhatmin)^2)/length(yhatmin)

  paste0(pheno," 1se lambda")
  res[, paste0(pheno," 1se lambda")] <- signif(c(mse_1se, L_se1[-1,]), digits = 4)
  res[, paste0(pheno," min lambda")] <- signif(c(mse_min, L_min[-1,]), digits = 4)
}


res[,grep("1se lambda",colnames(res))]

write.table(res,
            "variableImportance.tsv",
            col.names = T,
            row.names = T)

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
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




