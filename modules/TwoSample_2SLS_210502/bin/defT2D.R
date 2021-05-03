# ---------------------------------------------
#
# T2D
# 
# ---------------------------------------------

defT2D = list(f.20002 = c("1223"),
              f.41270 = c("E11"),
              f.41271 = c("25000","25002"),
              exclude = c(0,0,0)
)


all(rownames(icdCodesList$ICD10) == df$sample.id)
nSamples = dim(icdCodesList$ICD10)[1]


T2Dpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                      icd10 = 0,
                      icd9 = 0,
                      illSR = 0,
                      stringsAsFactors = F
)


#icd 10
idx = grep(defT2D$f.41270, icdCodesList$ICD10)
icdCodesList$ICD10[idx]

idx = unique(idx%%nSamples)
T2Dpheno$icd10[idx] <- 1

#icd 9

grep(defT2D$f.41271[1], icdCodesList$ICD9)
idxT2D = which(icdCodesList$ICD9 %in% defT2D$f.41271)
idxT2D = unique(idxT2D%%nSamples)
T2Dpheno$icd9[idxT2D] <- 1

# self reported
idxT2D = which(icdCodesList$illnessSelfreported %in% defT2D$f.20002)
idxT2D = unique(idxT2D%%nSamples)
T2Dpheno$illSR[idxT2D] <- 1
sum(rowSums(T2Dpheno[,-1]) >= 1)



