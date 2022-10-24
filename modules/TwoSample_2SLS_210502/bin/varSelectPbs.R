# ---------------------------------------------
#
# Variable selection for predicting LA volume&function
#
# ---------------------------------------------
#
# data & load
#

library(rstanarm)
options(mc.cores = parallel::detectCores())
library(loo)
library(projpred)
library(bayesplot)

SEED <- 87

set.seed(SEED)


load("dfVar.rda", verbose = T)

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


args <- commandArgs(trailingOnly=TRUE)
i <- as.numeric(args[1])
phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")


# 1
pheno <- phenos[i]
y <- dfVarSample[, pheno]

fitg <- stan_glm(y ~ age + sex + af + t2d + bmi + height + sbp + hr,
                 data = dfVarSample, 
                 na.action = na.fail, 
                 family = gaussian(), 
                 QR = TRUE,
                 iter = 10000,
                 seed = SEED)



#mcmc_areas(as.matrix(fitg),prob_outer = .99)
#mcmc_pairs(as.matrix(fitg),pars = c("age","sex","af","bmi"))



# ---------------------------------------------
#
# projective predictive variable selection using the previous full model. 
# A fast leave-one-out cross-validation approach (Vehtari, Gelman and Gabry, 2017) 
# is used to choose the model size.
#

# For a simple linear model (without multilevel structure), the fastest method is to use L1–search.
print("Running cv_varsel:")
ref <- get_refmodel(fitg)
fitg_cv <- cv_varsel(ref, method = 'forward', cv_method = 'LOO', K = NULL)

print("finished cv_varsel")
(nv_a10 <- suggest_size(fitg_cv, alpha = 0.1))
(nv_a32 <- suggest_size(fitg_cv, alpha = 0.32))


print("Running project:")
projg_a10 <- project(fitg_cv, nterms = nv_a10, ndraws = 4000)
projg_a32 <- project(fitg_cv, nterms = nv_a32, ndraws = 4000)



models.fn <- paste0("fit_", pheno, ".rda")
save(fitg_cv, fitg, projg_a32, projg_a10, nv_a10, nv_a32, file = models.fn)








#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################


load(models.fn, verbose = T)
round(colMeans(as.matrix(projg_a10)), 4)
round(posterior_interval(as.matrix(projg_a10)), 4)

#plot(fitg_cv, stats = c('elpd', 'rmse'))
