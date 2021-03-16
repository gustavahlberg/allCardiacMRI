#
# SBP
#
# ---------------------------------------------
#
# old
#

h5readAttributes(h5.fn,"f.4080")
h5readAttributes(h5.fn,"f.4080/f.4080")
sbp = h5read(h5.fn,"f.4080/f.4080")
rownames(sbp) = sample.id[,1]

sbp = sbp[as.character(allTab$IID),]
sbp.2 = ifelse(sbp[,c(5)] <=  sbp[,c(6)] & sbp[,c(5)] != -9999, 
               sbp[,c(5)],  ifelse( sbp[,c(6)] == -9999, sbp[,c(5)],  sbp[,c(6)] ))
sbp.3 = sbp[sbp.2 == -9999,]
sbp.4 = ifelse(sbp.3[,c(1)] <=  sbp.3[,c(2)] & sbp.3[,c(1)] != -9999, 
               sbp.3[,c(1)],  ifelse( sbp.3[,c(2)] == -9999, sbp.3[,c(1)],  sbp.3[,c(2)] ))

sbp.5 = sbp.3[sbp.4 == -9999,]
sbp.6 = ifelse(sbp.5[,c(3)] <=  sbp.5[,c(4)] & sbp.5[,c(4)] != -9999, 
               sbp.5[,c(3)],  ifelse( sbp.5[,c(4)] == -9999, sbp.5[,c(3)],  sbp.5[,c(4)] ))
sbp.5[sbp.6 == -9999,]

#check
any(duplicated(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6))))
length(c(names(sbp.2[sbp.2 != -9999]), names(sbp.4[sbp.4 != -9999]), names(sbp.6)))

sbp.2[names(sbp.4)] <- sbp.4
sbp.2[names(sbp.6)] <- sbp.6
sbp.2[sbp.2 == -9999] <- NA


all(allTab$FID == names(sbp.2))
all(allTab$sbp == sbp.2, na.rm = T)

sum(is.na(sbp.2))
sum(is.na(allTab$sbp))

# ---------------------------------------------
#
# new sbp
#

h5readAttributes(h5.fn,"f.4080")
h5readAttributes(h5.fn,"f.4080/f.4080")
sbp = h5read(h5.fn,"f.4080/f.4080")
rownames(sbp) = sample.id[,1]

sbp = sbp[as.character(allTab$IID),]

sbp[(sbp == -9999)] <- NA
sbp <- rowMeans(sbp, na.rm = T)

hist(sbp)
plot(sbp, allTab$sbp)

h5readAttributes(h5.fn,"f.12674")
sbpPwa <- h5read(h5.fn,"f.12674/f.12674")

h5readAttributes(h5.fn,"f.12697")
sbpPwa <- h5read(h5.fn,"f.12697/f.12697")
rownames(sbpPwa) = sample.id[,1]
sbpPwa[sbpPwa == -9999] <- NA
sbpPwa <- rowMeans(sbpPwa, na.rm = T)
sbpPwa[sbpPwa == 'NaN'] <- NA
samplesNAsbp <- names(sbp[is.na(sbp)])

sum(is.na(sbpPwa[samplesNAsbp]))
sbp[is.na(sbp)] <- sbpPwa[samplesNAsbp]


sum(is.na(sbp[samples2includeAll]))
hist(sbp[samples2includeAll])

all(rownames(allTab) == names(sbp))
allTab$newSBP <- sbp


# ---------------------------------------------
#
# adjust sbp
#

bpMed <- read.table("bp_lower.txt")$V1
med <- read.table("coding4.tsv",
                  header = T,
                  sep = "\t")

bpMedCodes <- unlist(sapply(bpMed, function(x){
  med$coding[grep(x,med$meaning, fixed = T)]
}))


h5readAttributes(h5.fn, "f.6153")
idxF6153 <- which(rowSums(h5read(h5.fn, "f.6153/f.6153") == 2) > 0)
h5readAttributes(h5.fn, "f.6177")
idxF6177 <- which(rowSums(h5read(h5.fn, "f.6177/f.6177") == 2) > 0)

h5readAttributes(h5.fn, "f.20003")
treatment <- h5read(h5.fn, "f.20003/f.20003")
rownames(treatment) <- sample.id
idx = which(treatment %in% bpMedCodes)
sort(table(treatment[idx]))

idxF20003 = unique(idx%%nrow(treatment))

# union
idxBP <- unique(c(idxF6153,idxF6177,idxF20003))
samples.bpmed.id <- sample.id[idxBP]

allTab$bpMed <- 0

sum(allTab$IID %in% samples.bpmed.id)
allTab$bpMed[allTab$IID %in% samples.bpmed.id] <- 1


# ---------------------------------------------
#
# add adjusted SBP
#

allTab$SBP_adj15mmhg <- allTab$newSBP
allTab$SBP_adj10mmhg <- allTab$newSBP

allTab$SBP_adj15mmhg[allTab$bpMed == 1] <- allTab$SBP_adj15mmhg[allTab$bpMed == 1] + 15
allTab$SBP_adj10mmhg[allTab$bpMed == 1] <- allTab$SBP_adj10mmhg[allTab$bpMed == 1] + 10



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################



