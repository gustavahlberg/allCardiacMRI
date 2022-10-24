# ---------------------------------------------
#
# effect modification by AF
#
# ---------------------------------------------

phenoTab <- read.table("../../data/ukbCMR.all.boltlmm_200506.sample",
                       stringsAsFactors = F,
                       header = T)

load(file = "data/predictions_200825.rda", verbose = T)
load(file = "dataFrame_210503.rda")
sampleSet <- rownames(df[(df$sample.id %in% phenoTab$IID ), ])
rownames(phenoTab) <- as.character(phenoTab$IID)

SEED = 1234
set.seed(SEED)
length(sampleSet)

dfVar <- data.frame(ilamax = phenoTab[sampleSet,]$ilamax,
                    ilamin = phenoTab[sampleSet,]$ilamin,
                    laaef = phenoTab[sampleSet,]$laaef,
                    lapef = phenoTab[sampleSet,]$lapef,
                    latef = phenoTab[sampleSet,]$latef,
                    age = scale(df[sampleSet,]$age),
                    sex = df[sampleSet,]$sex,
                    af = df[sampleSet,]$AF,
                    hf = df[sampleSet,]$hf_cm,
                    t2d = df[sampleSet,]$T2D,
                    bmi = scale(df[sampleSet,]$bmi),
                    height = scale(df[sampleSet,]$height),
                    sbp = scale(df[sampleSet,]$SBP_adj10mmhg),
                    hr = scale(df[sampleSet,]$HR),
                    PC1 =  df[sampleSet,]$PC1,
                    PC2 =  df[sampleSet,]$PC2,
                    PC3 =  df[sampleSet,]$PC3,
                    PC4 =  df[sampleSet,]$PC4,
                    afprs = scale(pred)
                    )


rownames(dfVar) <- sampleSet
prsSub <- prs[sampleSet,]

# ---------------------------------------------
#
# effect modification by AF
#
# ---------------------------------------------

effectMod <- list()

phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")

for(pheno in phenos) {
  y <- dfVar[,pheno]
  iv <- prsSub[, pheno]

  fit0 <- glm(y ~ af + afprs + sex + age + PC1 + PC2 + PC3 + PC4, 
              data = dfVar, family = gaussian())
  fitInt <- glm(y ~ af + afprs + af*afprs + sex + age + PC1 + PC2 + PC3 + PC4, 
              data = dfVar, family = gaussian())

  res2 <- signif(summary(fitInt)$coefficients[c(2,3,10),-3], digits = 3)
  panova <- signif(anova(fit0, fitInt, test='Chisq')$`Pr(>Chi)`[2], digits = 3)

  effectMod[[pheno]] <- rbind(res2, c(NA, NA, panova)) 

}


summary(fit0 <- glm(latef ~ af + afprs + sex + age, 
                    data = dfVar[dfVar$af == 0,], family = gaussian()))
summary(fit0 <- glm(latef ~ af + afprs + sex + age, 
            data = dfVar, family = gaussian()))
summary(fit0 <- glm(latef ~ af + afprs + af:afprs + sex + age , 
                    data = dfVar, family = gaussian()))


modTab <- do.call(rbind, effectMod)

write.table(x = modTab, 
            file = "effectMod.tsv",
            col.names = T,
            row.names = T,
            quote = F)








