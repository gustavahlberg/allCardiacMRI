#
#
# define phenos
#
#
# -------------------------------


samplesCMR = as.character(allTab$FID)
source("bin/icd.R")



# ---------------------------------------------
#
# Type 2 Diabetes
#

source("bin/defT2D.R")

all(T2Dpheno$sample.id == allTab$FID)
allTab$T2D = ifelse(rowSums(T2Dpheno[,-1]) >= 1,1,0)


# ---------------------------------------------
#
# CAD
#

source("bin/defCAD.R")
all(CADpheno$sample.id == allTab$FID)
allTab$CAD = ifelse(rowSums(CADpheno[,-1]) >= 1,1,0)
sum(allTab[samples2includeAll,]$CAD)/35658




# ---------------------------------------------
#
# Hypertension
#


source("bin/defHT.R")
all(HTpheno$sample.id == allTab$FID)
allTab$HT = ifelse(rowSums(HTpheno[,-1]) >= 1,1,0)
sum(allTab[samples2includeAll,]$HT)/35628



# ---------------------------------------------
#
# Valve disease
#


source("bin/defValve.R")
all(Valvepheno$sample.id == allTab$FID)
allTab$Valve = ifelse(rowSums(Valvepheno[,-1]) >= 1,1,0)
sum(allTab[samples2includeAll,]$Valve)/36528


