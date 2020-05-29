#
# make LD matrix w/ snpstat
#
# --------------------------
# use R3.6
# -------------------------------------
#
# load, corr and write
#

library(data.table)
args = commandArgs(trailingOnly=TRUE)
mat.fn = args[1]
z.fn = args[2]

exld = as.character(read.table("../../data/sample2exclude.all.snpTest_200506.list",
                               stringsAsFactors = F, header = F)$V1)

#z.fn = "data/rntrn_ilamax_1.chr1.z"
ztab= read.table(z.fn,
                 stringsAsFactors =F,
                 header = T)

exld = paste0("X",exld)
#mat.fn="bimbam/rntrn_ilamax_1.chr1.dosage"
dosageMat = fread(mat.fn,
                  stringsAsFactors =F,
                  header = T)

dosageMat <- data.frame(dosageMat)
dosageMat <- dosageMat[,-which(colnames(dosageMat) %in% exld)]

# rm duplicates
snpids = paste0(ztab$chromosome,":",ztab$position,"_",ztab$allele1,"_",ztab$allele2)
snpids2 = paste0(dosageMat$chromosome,":",dosageMat$position,"_",
                 dosageMat$alleleA,"_",dosageMat$alleleB)
dosageMat = dosageMat[snpids2 %in% snpids,]

ldMat.fn = paste0("ldFiles/", gsub("dosage","ld",basename(mat.fn)))

# cor
dosMatEff = dosageMat[,-c(1:6)]
ldMat = cor(t(dosMatEff), method = "pearson")


# print
fwrite(ldMat,
       ldMat.fn,
       quote = F,
       row.names = F,
       col.names = F,
       sep = " "
       )


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################



## cmd=paste("gunzip -c", vcf.fn," | grep -v '#' | cut -f 2 | sed -e 1b -e '$!d'")
## rangeVcf = system(cmd, intern = T)
## rangeVcf = as.numeric(rangeVcf)

## gg = GenomicRanges::GRanges(seqnames="10", IRanges::IRanges(rangeVcf[1] - 10, rangeVcf[2]+10))
## snpMat = vcf2sm(Rsamtools::TabixFile(vcf.fn), gr=gg, nmetacol=9L)


## head(snpMat)
## ldMat = ld(snpMat,  stats=c("R.squared"), depth = dim(snpMat)[2] - 1)

## ldMat = as.matrix(ldMat)
## test = ldMat[1:4,1:4]
## rownames(test)= NULL ; colnames(test) = NULL

## test[lower.tri(test)] = t(test)[lower.tri(test)]
## diag(test) <- 1


## zfile = read.table("data/rntrn_lamin_1.chr10.z",
##            header = T,
##            stringsAsFactors = F)

## tmp = (snpMat@.Data[,1:4])
## tmp = (snpMat[,1:4])
## tmp2 = apply(tmp, 2, as.numeric)
## rownames(tmp)= NULL ; colnames(tmp) = NULL

## cor(tmp2,method = "pearson")

## test
## zfile[1:4,]


## tmp2 = scale(tmp2)
## tmp2 = nrow(tmp2)^-1*(t(tmp2) %*% tmp2 )
## rownames(tmp2)= NULL ; colnames(tmp2) = NULL
## round(tmp2,3)
