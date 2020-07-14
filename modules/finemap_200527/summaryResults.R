# -------------------------------
#
# summary results
#
# -------------------------------


sumresMat = matrix(NA, 
                   nrow = 7, ncol = 8, 
                   dimnames = list(c(),
                                   c("locus","finemapped_rsid","gene","annontation",
                                     "transcript","HGSV.p","CADD","EXAC_AF")))
sumres = read.table("resFinemapMissense.tab",
                    stringsAsFactors = F,
                    header = F)
sumres = sumres[-c(2,3,5:8)]
sumres$V1 = gsub('vcfAnnonted/|.csnps.annon.dbnsp.vcf','',sumres$V1)

infos = strsplit(sumres$V9,";")

for(i in 1:length(infos)) {
  info = infos[[i]]
  CADD = gsub("dbNSFP_CADD_phred=","",info[grep("dbNSFP_CADD_phred",info)])
  EXACAF = gsub("dbNSFP_ExAC_AF=","",info[grep("dbNSFP_ExAC_AF=",info)])
  annotation = unlist(strsplit(info[1],"\\|"))[2]
  gene = unlist(strsplit(info[1],"\\|"))[4]
  HGVS = unlist(strsplit(info[1],"\\|"))[11]
  trans = unlist(strsplit(info[1],"\\|"))[7]

  sumresMat[i,] <- c(sumres$V1[i], sumres$V4[i], gene,
                     annotation, trans, HGVS, CADD, EXACAF)

}


sumresMat = data.frame(sumresMat, stringsAsFactors = F)
sumresMat$sentinel = c("rs4074536","rs2073708","rs2014576","rs17143007","rs6735077","rs4074536","rs133885")
sumresMat$CADD = as.numeric(sumresMat$CADD)
sumresMat$EXAC_AF = as.numeric(sumresMat$EXAC_AF)
sumresMat$pheno =gsub("rntrn_|_\\d+.chr\\d+","",sumresMat$locus)
sumresMat$log10bf = NA

rownames(sumresMat) <- sumresMat$locus

for(i in 1:dim(sumresMat)[1]) {
  s = snpsList[[sumresMat$locus[i]]]
  sumresMat$log10bf[i] = s[s$rsid == sumresMat$finemapped_rsid[i],]$log10bf
}



write.xlsx(sumresMat, 
           file = "sumresFinemap.xlsx",
           row.names = F
           )


# -------------------------------
#
# load sentinels & coloc
#


senttab = read.table("../clumping_200518/sentinels.tsv",
                     header = T,
                     sep = "\t",
                     stringsAsFactors = F)
senttab$Pheno = gsub("rntrn_","",senttab$Pheno)

coloctab = read.table("../coloc_200530/results/colocPP_Results_200605.tab",
                     header = T,
                     sep = " ",
                     stringsAsFactors = F)

colocList = lapply(split(coloctab, coloctab$pheno), function(x) split(x,x[['sentinel']]))
colocGenes = lapply(colocList, function(x) lapply(x, function(y) unique(y[['hgnc']])))


senttab$Pheno
senttab$eqtlColoc = ""
senttab$fineMappedMissense = ""

for(i in 1:dim(senttab)[1]) {
  
  genes = paste(colocGenes[[senttab[i,]$Pheno]][[senttab[i,]$sentinel_rsid]],collapse = ",")
  senttab[i,]$eqtlColoc <- genes
  
  if(any(sumresMat$pheno %in% senttab[i,]$Pheno & sumresMat$sentinel %in% senttab[i,]$sentinel_rsid)) {
    anno = sumresMat[sumresMat$pheno %in% senttab[i,]$Pheno & sumresMat$sentinel %in% senttab[i,]$sentinel_rsid,]
    senttab[i,]$fineMappedMissense = paste(anno$gene, anno$finemapped_rsid, anno$CADD)
  }
}


senttab$chrPos = paste(senttab$chr, senttab$bp, sep = ":")
senttab = senttab[order(senttab$chr,senttab$bp, senttab$Pheno),]

# print
write.xlsx(senttab,
           file = "functionalCharSummary.xlsx",
           )


