# --------------------------------
# 
# 3) stacked C+T
#
# ----------------------------------
#
# load
#


library(parallel)
load("../prs_ct_bayes_200724/data/sampleData.rda", verbose = T)
load("data/list_snp_id.rda", verbose = TRUE)
load("data/samplesOrdered.rda", verbose = TRUE)
load("data/dfAF.rda", verbose = TRUE)
load("data/all_keep.rda", verbose = TRUE)

matdata = "data/afCohort.rds"
phenoTabIncl = phenoTab[ind.indiv,]
 
ukbb <- snp_attach(matdata)
G <- ukbb$genotypes

CHR <- as.integer(ukbb$map$chromosome)
POS <- ukbb$map$physical.pos
map <- ukbb$map
map$marker.ID <- paste(paste(gsub("^0","",map$chromosome), map$physical.pos, sep = ":"), map$allele1, map$allele2, sep = "_")


info_snp$markerID <- paste(paste(info_snp$chr, info_snp$pos, sep = ":"), info_snp$a0, info_snp$a1, sep = "_")

all(info_snp$markerID == map$marker.ID)

lpval <- -log10(info_snp$p)
beta = -info_snp$beta
y = df$AF

# ---------------------------------
#
# index
#

ind.test = which(df$sample.id %in% phenoTab$FID)
ind.train = which(!df$sample.id %in% phenoTab$FID)


# ---------------------------------
#
# stacked multi prs
#

tmp <- tempfile(tmpdir = 'results')
grid.lps = seq(from= -log10(5e-3), to = -log10(5e-08), by = exp(log(0.4)) )
grid.lps = c(grid.lps, -log10(5e-08))


multi_PRS <- snp_grid_PRS(
    G, all_keep, betas = beta, lpS = lpval, ind.row = ind.train,
    n_thr_lpS = length(grid.lps),
    grid.lpS.thr = grid.lps,
    backingfile = paste0(tmp, "_scores"), ncores = 20
)

# stack models w/o covar
## final_mod <- snp_grid_stacking(
##     multi_PRS,
##     y[ind.train],
##     ncores = 20
## )


X = as.matrix(df[,c('age','sex',paste0('PC', 1:4))])

# stack models w/ covar
final_mod_covar <- snp_grid_stacking(
    multi_PRS,
    y[ind.train],
    ncores = 20,
    covar.train = X[ind.train,],
    pf.covar = c(0,0,1,1,1,1)
)

save(final_mod_covar, file = "results/stackedFinalMod_covar.rda")

mod <- final_mod$mod
plot(mod)
summary(mod)

new_beta <- final_mod$beta.G
nb_SCT <- length(ind <- which(new_beta != 0))


pred <- final_mod$intercept +
    big_prodVec(G, new_beta[ind], ind.row = ind.test, ind.col = ind)


predCovar = X[ind.test,] %*% final_mod_covar$beta.covar 
#pred <- big_prodVec(G, new_beta[ind], ind.row = ind.train, ind.col = ind)
print(bigstatsr::AUC(pred, y[ind.test]))


save(pred, predCovar, file = "results/predictions_200825.rda")


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################

load("results/stackedFinalMod_covar.rda", verbose = TRUE)
load("results/stackedFinalMod.rda", verbose = TRUE)


row.names(phenoTab) <- phenoTab$FID
phenoTabGwas <- phenoTab[phenoTab$FID %in% df$sample.id,]
all(phenoTabGwas$FID %in% df[ind.test,]$sample.id)
phenoTabGwas = phenoTabGwas[df[ind.test,]$sample.id,]
all(phenoTabGwas$FID == df[ind.test,]$sample.id)

phenoTabGwas$AF <- df[ind.test,]$AF
idxAF = which(phenoTabGwas$AF == 1)

summary(lm(laaef ~ scale(pred)[-idxAF] + predCovar[-idxAF] + age  + sex, data = phenoTabGwas[-idxAF,]))

summary(lm(laaef ~ scale(pred)[-idxAF] + age  + sex,
           data = phenoTabGwas[-idxAF,]))


summary(lm(laaef ~ scale(pred) + age  + sex, data = phenoTabGwas))
summary(lm(laaef ~ scale(pred) , data = phenoTabGwas))
