# ---------------------------------------------
#
# 2SLS
#
# ---------------------------------------------
#
# create df
#


testSet <- rownames(df[!df$sample.id %in% phenoTab$IID, ])
trainingSet <- rownames(df[(df$sample.id %in% phenoTab$IID ), ])

rownames(phenoTab) <- as.character(phenoTab$IID)


df$ilamin <- NA;  df$ilamax <- NA; df$laaef <- NA;
df$lapef <- NA; df$latef <- NA; 


# load some more
# extraData <- fread("../../../AF_200K_exomes_201027/data/phenotypes/diseasePhenos_210225.tab.gz")
# extraData <- data.frame(extraData)


# ---------------------------------------------
#
# file data
#


df[trainingSet, ]$laaef <- scale(phenoTab[trainingSet, ]$laaef)
df[trainingSet, ]$lapef <- scale(phenoTab[trainingSet, ]$lapef)
df[trainingSet, ]$latef <- scale(phenoTab[trainingSet, ]$latef)
df[trainingSet, ]$ilamax <- scale(phenoTab[trainingSet, ]$ilamax)
df[trainingSet, ]$ilamin <- scale(phenoTab[trainingSet, ]$ilamin)



# ---------------------------------------------
#
# 1st step, predict 
#

# variables SD scaled and mean centered

# ---------------------------------------------
#
# AF, 2nd step
#

AF_TwoSls <- list()

for(pheno in phenos) {

  df$iv  <- prs[df$sample.id, pheno]
  fit <- glm(AF ~ iv + SBP_adj10mmhg + sex + age + PC1 + PC2 + PC3 + PC4,
             family = binomial(),
             data = df[testSet, ])

  AF_TwoSls[[pheno]] <- list(mod = fit, modSum = summary(fit))

}


# ---------------------------------------------
#
# HF, 2nd step
#


HF_TwoSls <- list()

for(pheno in phenos) {
  
  df$iv  <- prs[df$sample.id, pheno]
  fit <- glm(hf_cm ~ iv + SBP_adj10mmhg +sex + age + PC1 + PC2 + PC3 + PC4,
             family = binomial(),
             data = df[testSet, ])
  
  HF_TwoSls[[pheno]] <- list(mod = fit, modSum = summary(fit))
  
}



# ---------------------------------------------
#
# all cause Stroke, 2nd step
#

stroke_TwoSls <- list()

for(pheno in phenos) {
  
  df$iv  <- prs[df$sample.id, pheno]
  fit <- glm(stroke ~ iv + SBP_adj10mmhg + sex + age + PC1 + PC2 + PC3 + PC4,
             family = binomial(),
             data = df[testSet, ])
  
  stroke_TwoSls[[pheno]] <- list(mod = fit, modSum = summary(fit))
  
}

# ---------------------------------------------
#
# ischemic cause Stroke, 2nd step
#

ischStrk_TwoSls <- list()

for(pheno in phenos) {
  
  df$iv  <- prs[df$sample.id, pheno]
  fit <- glm(nonheam_stroke ~ iv + SBP_adj10mmhg + sex + age + PC1 + PC2 + PC3 + PC4,
             family = binomial(),
             data = df[testSet, ])
  
  ischStrk_TwoSls[[pheno]] <- list(mod = fit, modSum = summary(fit))
  
}




# ---------------------------------------------
#
# print table
#

dfTest <- df[testSet, ]
sum(dfTest$ischStroke[!is.na(dfTest$SBP_adj10mmhg)])
nStroke<- sum(dfTest$stroke[!is.na(dfTest$SBP_adj10mmhg)])
nHF <- sum(dfTest$hf_cm[!is.na(dfTest$SBP_adj10mmhg)])
nAF <- sum(dfTest$AF[!is.na(dfTest$SBP_adj10mmhg)])


res <- matrix(data = NA, nrow = 20, ncol = 3)
colnames(res) <- c("Beta","SE","P")
nme <- c()

for(pheno in phenos) {
  for(d in c("AF", "HF", "Stroke", "isch. Stroke")) {
    nme <- c(nme,  paste0(pheno," ",d))
  }
}

rownames(res) <- nme

for(pheno in phenos) {
  
  nme_af <- paste0(pheno," AF")
  nme_hf <- paste0(pheno," HF")
  nme_strk <- paste0(pheno," Stroke")
  nme_istrk <- paste0(pheno," isch. Stroke")
  
  res[nme_af,] <- AF_TwoSls[[pheno]]$modSum$coefficients[2,-3]
  res[nme_hf,] <- HF_TwoSls[[pheno]]$modSum$coefficients[2,-3]
  res[nme_strk,] <- stroke_TwoSls[[pheno]]$modSum$coefficients[2,-3]
  res[nme_istrk,] <- ischStrk_TwoSls[[pheno]]$modSum$coefficients[2,-3]
  
}

res <- data.frame(res)

res[, "OR"] <- exp(res[, 'Beta'])
resRounded <- signif(res, digits = 2)

table.fn <- "results2SLS.tsv"

write.table(resRounded, 
            file = table.fn,
            col.names = T,
            row.names = T,
            quote = F,
            sep = " ")



# ---------------------------------------------
#
# save
#

save(AF_TwoSls, HF_TwoSls, 
     stroke_TwoSls, ischStrk_TwoSls,
     file = "results_2SLS.rda")


################################################
# EOF # EOF ## EOF ## EOF ## EOF ## EOF ## EOF #
################################################


