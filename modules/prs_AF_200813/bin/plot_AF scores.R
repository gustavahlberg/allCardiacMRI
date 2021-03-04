#
#
# 5) Plot af scores
#
# ----------------------------------

library(rethinking)
load("data/sampleData.rda", verbose = T)
#load("data/list_snp_id.rda", verbose = TRUE)
load("data/samplesOrdered.rda", verbose = TRUE)
load("data/dfAF.rda", verbose = TRUE)
load("data/all_keep.rda", verbose = TRUE)
load("results/predictions_200825.rda", verbose = TRUE)
load("results/stackedFinalMod_covar.rda", verbose = TRUE)


# ---------------------------------
#
# index & sort
#

ind.test = which(df$sample.id %in% phenoTab$FID)
ind.train = which(!df$sample.id %in% phenoTab$FID)

row.names(phenoTab) <- phenoTab$FID
phenoTabGwas <- phenoTab[phenoTab$FID %in% df$sample.id,]
all(phenoTabGwas$FID %in% df[ind.test,]$sample.id)
phenoTabGwas = phenoTabGwas[df[ind.test,]$sample.id,]
all(phenoTabGwas$FID == df[ind.test,]$sample.id)

phenoTabGwas$AF <- df[ind.test,]$AF
idxAF = which(phenoTabGwas$AF == 1)

summary(lm(laaef ~ pred[-idxAF] + predCovar[-idxAF] + age  + sex, data = phenoTabGwas[-idxAF,]))

X = as.matrix(phenoTabGwas[,c('age','sex',paste0('PC', 1:4))])
predCovar = X %*% final_mod_covar$beta.covar
predCovar 

pred2 = scale(pred + predCovar)
pred = scale(pred)

print(bigstatsr::AUC(pred + predCovar, phenoTabGwas$AF))
print(bigstatsr::AUC(pred, phenoTabGwas$AF))
summary(lm(laaef ~ pred[-idxAF] + predCovar[-idxAF] , data = phenoTabGwas[-idxAF,]))
summary(lm(laaef ~ pred2 , data = phenoTabGwas))

##########################################################################
#
# plot 1 
#

head(phenoTabGwas)
colGrad <- colorRampPalette(c("#d73027","#ffffed","#4575b4"))(256)

c1 = as.character(cut(pred, breaks = 256, labels = colGrad,include.lowest = T))
table(c1)

plot(phenoTabGwas$laaef, phenoTabGwas$ilamin, type = 'n')
points(phenoTabGwas$laaef[pred < - 2], phenoTabGwas$ilamin[pred < -2], col = c1[pred < -2], pch = 19)
points(phenoTabGwas$laaef[pred > 2], phenoTabGwas$ilamin[pred > 2], col = c1[pred > 2], pch = 19)

mean(phenoTabGwas$AF[pred > 2])
mean(phenoTabGwas$AF)


# --------------------------------------------------
#
# plot 2 
#


plot(pred, phenoTabGwas$laaef)
fit <- lm(laaef ~ pred, data = phenoTabGwas)
abline(fit)
fit <- lm(laaef ~ pred +  age  + sex  + poly(ilamin,2) + dbp + sbp , data = phenoTabGwas)
summary(fit)

summary(lm(laaef ~ pred + predCovar, data = phenoTabGwas))
fit <- lm(laaef ~ pred2 , data = phenoTabGwas)
plot(fit)



