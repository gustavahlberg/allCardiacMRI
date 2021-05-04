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

SEED = 87

set.seed(SEED)


load("dfVar.rda")

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

print("Running cv_varsel:")
ref <- get_refmodel(fitg)
fitg_cv <- cv_varsel(ref, method='forward', cv_method='LOO')


models.fn = paste0("fit_", pheno, ".rda")
save(fitg_cv, fitg, save = models.fn)

