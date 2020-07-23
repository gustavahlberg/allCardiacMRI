#
# Run LCV
#
# -----------------------------------------------
#
# configs
#

library(readr)
library(dplyr)
library(data.table)


args <- commandArgs(trailingOnly = TRUE)
exposure = args[1]
outcome = args[2]

#exposure = 'laaef'
#outcome = 'AF'

#setwd(".../LCV/")
source("LCV/R/RunLCV.R")
source("LCV/R/MomentFunctions.R")



# -----------------------------------------------
#
# load data
#

sumstats = data.frame(AF="sumstats/AF_sumstat.sumstats.gz",
                      HF="sumstats/HF_sumstat.sumstats.gz",
                      AS="sumstats/stroke.AS.EUR.sumstats.gz",
                      AIS="sumstats/stroke.AIS.EUR.sumstats.gz",
                      CES="sumstats/stroke.CES.EUR.sumstats.gz",
                      lamin="sumstats/rntrn_lamin.sumstats.gz",
                      ilamin="sumstats/rntrn_ilamin.sumstats.gz",
                      lamax="sumstats/rntrn_lamax.sumstats.gz",
                      ilamax="sumstats/rntrn_ilamax.sumstats.gz",
                      latef="sumstats/rntrn_latef.sumstats.gz",
                      laaef="sumstats/rntrn_laaef.sumstats.gz",
                      lapef="sumstats/rntrn_lapef.sumstats.gz",
                      stringsAsFactors = F)

X1 = fread(sumstats[,exposure], stringsAsFactors = F, header = T)
X1 = na.omit(data.frame(X1, stringsAsFactors =F))
X2 = fread(sumstats[,outcome], stringsAsFactors = F, header = T)
X2 = na.omit(data.frame(X2, stringsAsFactors =F))

#Load LD scores
ldscoresFile="ldscores/unannotated_LDscores.l2.ldsc"
X3=na.omit(read.table(ldscoresFile,header=TRUE,sep='\t',stringsAsFactors=FALSE))

X3 = X3[X3$MAF > 0.05,]

# -----------------------------------------------
#
# merge
#

m = merge(X3,X1,by="SNP")
data = merge(m,X2,by="SNP")

#Sort by position
data = data[order(as.numeric(data[,"CHR"]),as.numeric(data[,"BP"])),]

#Flip sign of one z-score if opposite alleles-shouldn't occur with UKB data
#If not using munged data, will have to check that alleles match-not just whether they're opposite A1/A2
mismatch = which(data$A1.x!=data$A1.y,arr.ind=TRUE)
data[mismatch,]$Z.y = data[mismatch,]$Z.y*-1
data[mismatch,]$A1.y = data[mismatch,]$A1.x
data[mismatch,]$A2.y = data[mismatch,]$A2.x

data = data[-which(data$CHR == 6 & data$BP > 29e6 & data$BP < 33e6),]


# -----------------------------------------------
#
# Run LCV-need to setwd to directory containing LCV package
#


LCV = RunLCV(as.numeric(data$L2), data$Z.x, data$Z.y)

sprintf("Exposure: %s, outcome: %s",
        exposure,
        outcome)

sprintf("Estimated posterior gcp=%.3f(%.3f), pval.gcpzero.2tailed = %.3f,log10(p)=%.3f; estimated rho=%.3f(%.3f)",
        LCV$gcp.pm,
        LCV$gcp.pse,
        LCV$pval.gcpzero.2tailed,
        log(LCV$pval.gcpzero.2tailed)/log(10),
        LCV$rho.est,
        LCV$rho.err)



