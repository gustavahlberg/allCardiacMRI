# ----------------------------------
#
# 3) stacked C + T 
#
# ---------------------------------
#
# load
#

pheno = 'ilamin'

library(bigsnpr)
load("data/sampleData.rda", verbose = T)
load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)


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

# shift beta's
beta = -1*regGwas$beta



# ---------------------------------
#
# clump
#

all_keep <- snp_grid_clumping(
    G, CHR, POS, lpS = lpval, ind.row = ind.train,
    grid.thr.r2 = c(0.1, 0.2, 0.5, 0.8),
    grid.base.size = c(50, 200, 500, 1000),
    ncores = 6
) 

######################################
#
# new index

ind.train = sample(ind.test, length(ind.test)/2)
ind.test = setdiff(ind.test, ind.train)


# ---------------------------------
#
# stacking
#


#res_file <- paste0("res_small/BRCA_", ic, ".rds")
tmp <- tempfile(tmpdir = 'results')


grid.lps = seq(from= -log10(1e-2), to = -log10(5e-08), by = exp(log(0.1))) 

multi_PRS <- snp_grid_PRS(
    G, all_keep, betas = beta, lpS = lpval, ind.row = ind.train,
    n_thr_lpS = length(grid.lps),
    grid.lpS.thr = grid.lps,
    backingfile = paste0(tmp, "_scores"), ncores = 10
)


# stack models
final_mod <- snp_grid_stacking(
    multi_PRS, y[ind.train], ncores = 6
)


mod <- final_mod$mod
plot(mod)
summary(mod)

new_beta <- final_mod$beta.G
nb_SCT <- length(ind <- which(new_beta != 0))

pred <- final_mod$intercept +
    big_prodVec(G, new_beta[ind], ind.row = ind.test, ind.col = ind)

cor(pred, y[ind.test])



# ---------------------------------
#
# C + T
#

library(tidyverse)

grid2 <- attr(all_keep, "grid") %>%
    mutate(thr.lp = list(attr(multi_PRS, "grid.lpS.thr")), num = row_number()) %>%
    unnest()
s <- nrow(grid2)

grid2$cor <- big_apply(multi_PRS, a.FUN = function(X, ind, s, y.train) {
    # Sum over all chromosomes, for the same C+T parameters
    single_PRS <- rowSums(X[, ind + s * (0:21)])
    cor(single_PRS, y.train)
  }, ind = 1:s, s = s, y.train = y[ind.train],
  a.combine = 'c', block.size = 1, ncores = 6)

grid2 %>% arrange(desc(cor))

grid2$corTest = sapply(1:dim(grid2)[1], function(i) {
    max_prs <- grid2[i,]
    ind.keep <- unlist(map(all_keep, max_prs$num))
    pred_max_prs <- snp_PRS(G, beta[ind.keep],
                            ind.test = ind.test,
                            ind.keep = ind.keep,
                            lpS.keep = lpval[ind.keep],
                            thr.list = max_prs$thr.lp)
    cor(pred_max_prs, y[ind.test])
})

i = 1
grid2 %>% arrange(desc(corTest))
max_prs <- grid2 %>% arrange(desc(cor)) %>% slice(i)

ind.keep <- unlist(map(all_keep, max_prs$num))
pred_max_prs <- snp_PRS(G, beta[ind.keep],
                        ind.keep = ind.keep,
                        lpS.keep = lpval[ind.keep],
                        thr.list = max_prs$thr.lp)


ind <- ind.keep[which(lpval[ind.keep] > max_prs$thr.lp)]
#nb_SCT <- length(ind <- which(new_beta != 0))

prsTest = big_prodVec(G, beta[ind], ind.row = ind.test, ind.col = ind)
print(cor(prsTest, y[ind.test]))

print(cor(pred_max_prs[ind.test], y[ind.test]))


df = data.frame(prs = pred_max_prs[,1],
                age = phenoTabIncl$age,
                sex = phenoTabIncl$sex)

fit = lm(y[c(ind.test,ind.train)] ~ prs + age +  sex, data = df[c(ind.test,ind.train),])
pred = predict(fit, df[ind.test,])



cor(pred_max_prs, y)
cor(pred, y[ind.test])

summary(lm(y[ind.test] ~ pred))
summary(lm(y ~ scale(pred_max_prs)))

summary(glm(phenoTabIncl[ind.test,]$af ~ scale(pred_max_prs[ind.test]), family = binomial))
summary(glm(phenoTabIncl[ind.test,]$af ~ prs + age + sex, data = df[ind.test,], family = binomial))
summary(glm(phenoTabIncl[ind.train,]$af ~ scale(prs) + age + sex, data = df[ind.train,], family = binomial))


#std_prs <- grid2 %>%
#    filter(thr.r2 == 0.3, size == 3333) %>%
#    arrange(desc(auc)) %>%
#    slice(1)
