# ---------------------------------------------
#
# Valve
# 

defValve = list(f.20002 = c("1490","1586","1587", 
                            "1584","1489","1488", "1585"),
              f.20004 = c("1100","1099"),
              f.41270 = c("I06","I080", "I082","I083", "I391","I05","I34",
                          "I080", "I081", "I083", "I390",
                          "I07","I36","I081", "I082", "I083",
                          "I37","I393"),
              f.41271 = c("3951","3959","4241","3940", "3942","3949","4240", "4243"),
              f.41272 = c("K26","K302","K25", "K301","K341", "K351",
                          "K27","K303","K28", "K304", "K357")
              )



all(rownames(icdCodesList$ICD10) == allTab$ID_1)
nSamples = dim(icdCodesList$ICD10)[1]


Valvepheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                      icd10 = rep(0, nSamples),
                      icd9 = rep(0, nSamples),
                      opcs4 = rep(0, nSamples),
                      illSR = rep(0, nSamples),
                      opSR = rep(0, nSamples),
                      stringsAsFactors = F
)


#icd 10
idx = which(icdCodesList$ICD10 %in% defValve$f.41270)
icdCodesList$ICD10[idx]

idx = unique(idx%%nSamples)
Valvepheno$icd10[idx] <- 1

#icd 9
icdCodesList$ICD9[grep(defValve$f.41271[3], icdCodesList$ICD9)]
idxValve = which(icdCodesList$ICD9 %in% defValve$f.41271)
idxValve = unique(idxValve%%nSamples)
Valvepheno$icd9[idxValve] <- 1

# self reported
idxValve = which(icdCodesList$illnessSelfreported %in% defValve$f.20002)
idxValve = unique(idxValve%%nSamples)
Valvepheno$illSR[idxValve] <- 1
sum(rowSums(Valvepheno[,-1]) >= 1)


# opcs4
idxValve = which(icdCodesList$OPCS4 %in% defValve$f.41272)
idxValve = unique(idxValve%%nSamples)
Valvepheno$opcs4[idxValve] <- 1
sum(rowSums(Valvepheno[,-1]) >= 1)


# opertation self reported
idxValve = which(icdCodesList$opCodeSelfReported %in% defValve$f.20004)
idxValve = unique(idxValve%%nSamples)
Valvepheno$opSR[idxValve] <- 1
sum(rowSums(Valvepheno[,-1]) >= 1)



