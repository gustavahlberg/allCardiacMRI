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
extraData <- fread("../../../AF_200K_exomes_201027/data/phenotypes/diseasePhenos_210225.tab.gz")
extraData <- data.frame(extraData)


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
# 1st step
#










# ---------------------------------------------
#
# AF, 2nd step
#








# ---------------------------------------------
#
# HF, 2nd step
#









# ---------------------------------------------
#
# Stroke, 2nd step
#








