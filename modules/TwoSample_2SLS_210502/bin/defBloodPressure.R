#
# SBP
#
# ---------------------------------------------
#
# old
#

# ---------------------------------------------
#
# new sbp
#

h5readAttributes(h5.fn,"f.4080")
h5readAttributes(h5.fn,"f.4080/f.4080")
sbp = h5read(h5.fn,"f.4080/f.4080")
rownames(sbp) = sample.id[,1]

sbp = sbp[as.character(df$sample.id),]

sbp[(sbp == -9999)] <- NA
sbp <- rowMeans(sbp, na.rm = T)

hist(sbp)


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


sum(is.na(sbp))
hist(sbp)

all(df$sample.id == names(sbp))
df$SBP <- sbp


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

df$bpMed <- 0

sum(df$sample.id %in% samples.bpmed.id)
df$bpMed[df$sample.id %in% samples.bpmed.id] <- 1


# ---------------------------------------------
#
# add adjusted SBP
#

df$SBP_adj15mmhg <- df$SBP
df$SBP_adj10mmhg <- df$SBP

df$SBP_adj15mmhg[df$bpMed == 1] <- df$SBP_adj15mmhg[df$bpMed == 1] + 15
df$SBP_adj10mmhg[df$bpMed == 1] <- df$SBP_adj10mmhg[df$bpMed == 1] + 10



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################



