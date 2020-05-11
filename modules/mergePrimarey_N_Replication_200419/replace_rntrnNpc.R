#
# merge sample sheets from primary and replication data sheets
# sort after original sample file
# ----------------------------------------------------------------
#
# list files
#


allSample.fn= "../../data/ukbCMR.all.snpTest_200506.sample"
allPheno.fn= "../../data/ukbCMR.all.boltlmm_200506.sample"
pcs.fn = "../flashpca_200419/results/ukbMriSubset.FlashPca.all.txt"



# ----------------------------------------------------------------
#
# load
#

snpTest = read.table(allSample.fn, header = T, stringsAsFactors = F)
bolt = read.table(allPheno.fn, header = T, stringsAsFactors = F)

voltab = bolt[-which(is.na(bolt$rntrn_lasv)),]
voltab$imgCenter = as.factor(voltab$imgCenter)

# ---------------------------------------------
#
# rtrn setup
#

rtrnFun <- function(y = NULL, X = NULL, subsetVec = NULL) {
      res = lm(y ~ X, subset = subsetVec)$residuals
        rntrnRes = rankNorm(res)
        rntrn <- rep(NA,length(y))
        rntrn[as.numeric(names(res))] <- rntrnRes
        return(rntrn)
      }


subsetVec = (voltab$hf_cm == 0 & voltab$mi == 0 & (voltab$bmi > 16 & voltab$bmi < 40) &
                 !(voltab$LVEF < 20 | voltab$LVEF > 80 | is.na(voltab$LVEF)))

X = model.matrix(~ voltab$sex + voltab$age + voltab$genotyping.array + voltab$imgCenter)[,-1]
Xbsa = model.matrix(~ voltab$sex + voltab$age +
                        voltab$bsa + voltab$genotyping.array + voltab$imgCenter)[,-1]




# ---------------------------------------------
#
# rtrn 
#

library(RNOmni)
LaParameters = c(colnames(voltab)[grep("la",colnames(voltab))], "aeTangent", "peTangent", "expansionidx")
LaParameters = LaParameters[-grep("rntrn",LaParameters)]

voltabbakk = voltab

# w/o bsa
for(laPar in LaParameters) {
      print(laPar)
        res = rtrnFun(y = voltabbakk[,laPar], X = X,subsetVec = subsetVec)
        par = paste0("rntrn_",laPar)
        voltabbakk[,par] <- res
      }


LaParameters = LaParameters[-grep("^i",LaParameters)]
# w/ bsa
for(laPar in LaParameters) {
      print(laPar)
        res = rtrnFun(y = voltabbakk[,laPar], X = Xbsa, subsetVec = subsetVec)
        par = paste0("rntrnBSA_",laPar)
        voltabbakk[,par] <- res
      }


voltab = voltabbakk


# ---------------------------------------------
#
# Put together
#

rownames(bolt) <- as.character(bolt$FID)
rntrnParameters = colnames(bolt)[grep("rntrn",colnames(bolt))]
bolt[as.character(voltab$FID),rntrnParameters] <- voltab[,rntrnParameters]


sapply(rntrnParameters, function(i) {
    cor(bolt[as.character(voltab$FID),i],voltab[,i])
    })



# ---------------------------------------------
#
# Add new PC's
#

. addPCs.R


# ---------------------------------------------
#
# Print results
#

all(bolt$FID == snpTest$ID_1[-1])
snpTest[-1,] = bolt


write.table(snpTest,
           file = allSample.fn,
           row.names = F,
           col.names = T,
           quote = F,
           sep = "\t"
           )


write.table(bolt,
           file = allPheno.fn,
           row.names = F,
           col.names = T,
           quote = F,
           sep = "\t"
           )



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
