# ---------------------------------------------
#
# CAD
# 

defCAD = list(f.20002 = c("1075"),
              f.20004 = c("1095","1107","1523"),
              f.41270 = c("I21|I22|I23|I241|I252"),
              f.41271 = c("410","411","412"),
              f.41272 = c("K40","K401","K402","K403","K404","K41","K411",
                          "K412","K413","K414","K45","K451","K452","K453",
                          "K454","K455","K49","K491","K492","K498","K499","K502",
                          "K75","K751","K752","K753","K754","K758","K759")
              )


all(rownames(icdCodesList$ICD10) == samplesCMR)
nSamples = dim(icdCodesList$ICD10)[1]


CADpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                      icd10 = rep(0, nSamples),
                      icd9 = rep(0, nSamples),
                      opcs4 = rep(0, nSamples),
                      illSR = rep(0, nSamples),
                      stringsAsFactors = F
)


#icd 10
idx = grep(defCAD$f.41270, icdCodesList$ICD10)
icdCodesList$ICD10[idx]

idx = unique(idx%%nSamples)
CADpheno$icd10[idx] <- 1

#icd 9

icdCodesList$ICD9[grep(defCAD$f.41271[3], icdCodesList$ICD9)]
idxCAD = which(icdCodesList$ICD9 %in% defCAD$f.41271)
idxCAD = unique(idxCAD%%nSamples)
CADpheno$icd9[idxCAD] <- 1

# self reported
idxCAD = which(icdCodesList$illnessSelfreported %in% defCAD$f.20002)
idxCAD = unique(idxCAD%%nSamples)
CADpheno$illSR[idxCAD] <- 1
sum(rowSums(CADpheno[,-1]) >= 1)


# opcs4
idxCAD = which(icdCodesList$OPCS4 %in% defCAD$f.41272)
idxCAD = unique(idxCAD%%nSamples)
CADpheno$opcs4[idxCAD] <- 1

sum(rowSums(CADpheno[,-1]) >= 1)


