#
# rank transform with sbp 
# 
# ----------------------------------------------------------------
#
# list files
#


allSample.fn= "../../data/ukbCMR.all.snpTest_200506.sample"
allPheno.fn= "../../data/ukbCMR.all.boltlmm_200506.sample"


# ----------------------------------------------------------------
#
# load
#

snpTest = read.table(allSample.fn, header = T, stringsAsFactors = F)


voltab = allTab[-which(is.na(allTab$rntrn_lasv)),]
voltab$imgCenter = as.factor(voltab$imgCenter)

voltab <- voltab[-which(is.na(voltab$newSBP)),]


# ---------------------------------------------
#
# rtrn setup
#

rtrnFun <- function(y = NULL, X = NULL, subsetVec = NULL) {
  res = lm(y ~ X, subset = subsetVec)$residuals
  rntrnRes = RankNorm(res)
  rntrn <- rep(NA,length(y))
  rntrn[as.numeric(names(res))] <- rntrnRes
  return(rntrn)
}


subsetVec = (voltab$hf_cm == 0 & voltab$mi == 0 & (voltab$bmi > 16 & voltab$bmi < 40) &
               !(voltab$LVEF < 20 | voltab$LVEF > 80 | is.na(voltab$LVEF)))

X15Hg = model.matrix(~ voltab$sex + voltab$age + voltab$genotyping.array + 
                       voltab$imgCenter + voltab$SBP_adj15mmhg)[,-1]

X10Hg = model.matrix(~ voltab$sex + voltab$age + voltab$genotyping.array + 
                       voltab$imgCenter + voltab$SBP_adj10mmhg)[,-1]


# ---------------------------------------------
#
# rtrn 
#

library(RNOmni)
LaParameters = c("ilamax", "ilamin", "laaef", "lapef", "latef")

voltabbakk = voltab

# adjusted 15mmHG
for(laPar in LaParameters) {
  print(laPar)
  res = rtrnFun(y = voltabbakk[,laPar], X = X15Hg,subsetVec = subsetVec)
  par = paste0("rntrn_bp15Hg",laPar)
  voltabbakk[,par] <- res
}


# adjusted 10mmHG
for(laPar in LaParameters) {
  print(laPar)
  res = rtrnFun(y = voltabbakk[,laPar], X = X10Hg, subsetVec = subsetVec)
  par = paste0("rntrn_bp10Hg",laPar)
  voltabbakk[,par] <- res
}



voltab = voltabbakk

cor(voltab$rntrn_bp15Hgilamax, voltab$rntrn_ilamax)

# ---------------------------------------------
#
# Put together
#


rntrnParameters = colnames(voltab)[grep("rntrn_bp1[05]Hg",colnames(voltab))]
allTab[,rntrnParameters] <- NA

allTab[as.character(voltab$FID),rntrnParameters] <- voltab[,rntrnParameters]


sapply(rntrnParameters, function(i) {
  cor(allTab[as.character(voltab$FID),i],voltab[,i])
})




# ---------------------------------------------
#
# Print results
#

all(allTab$FID == snpTest$ID_1[-1])

# 
# 
# write.table(snpTest,
#             file = allSample.fn,
#             row.names = F,
#             col.names = T,
#             quote = F,
#             sep = "\t"
# )
# 
# 
# write.table(bolt,
#             file = allPheno.fn,
#             row.names = F,
#             col.names = T,
#             quote = F,
#             sep = "\t"
# )
# 


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
