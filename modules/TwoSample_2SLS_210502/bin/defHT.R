# ---------------------------------------------
#
# HT
# 


defHT = list(f.20002 = c("1065","1072"),
             f.41270 = c("I10","I11","I110","I119","I12","I120","I129",
                         "I13","I130","I131","I132","I139","I15","I150","I151",
                         "I152","I158","I159"),
             f.41271 = c("401","4010","4011","4019","402","4020","4021","4029","403","4030",
                         "4031","4039","404","4040","4041","4049","405","4050","4051","4059")
)


all(rownames(icdCodesList$ICD10) == df$sample.id)
nSamples = dim(icdCodesList$ICD10)[1]

HTpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     stringsAsFactors = F)


#icd 10
idx = icdCodesList$ICD10 %in% defHT$f.41270
icdCodesList$ICD10[idx]

idx = unique(idx%%nSamples)
HTpheno$icd10[idx] <- 1

#icd 9

#icdCodesList$ICD9[grep(defHT$f.41271[3], icdCodesList$ICD9)]
idxHT = which(icdCodesList$ICD9 %in% defHT$f.41271)
idxHT = unique(idxHT%%nSamples)
HTpheno$icd9[idxHT] <- 1

# self reported
idxHT = which(icdCodesList$illnessSelfreported %in% defHT$f.20002)
idxHT = unique(idxHT%%nSamples)
HTpheno$illSR[idxHT] <- 1
sum(rowSums(HTpheno[,-1]) >= 1)

########################################################
# EOF # EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ##
########################################################