#
# make vcf
#
# -------------------------------
#
#
#


for(i in 1:length(snpsList)) {
  #i = 1
  snps = snpsList[[i]]
  vcfname = paste0("vcfs/",names(snpsList[i]),".csnps.vcf")
  
  vcf = data.frame(CHROM = snps$chromosome,
                   POS = snps$position,
                   ID = snps$rsid,
                   REF = snps$allele1,
                   ALT = snps$allele2,
                   QUAL = 100,
                   FILTER = ".",
                   INFO = "."
             )
  
  write.table(vcf,
              file = vcfname,
              sep = "\t",
              col.names = F,
              quote = F,
              row.names = F)
  
  cmd = paste("source annonate.sh",vcfname)
  system(cmd)
  
  cred = credList[[i]]

  
  vcf = data.frame(CHROM = cred$chromosome,
                   POS = cred$position,
                   ID = cred$rsid,
                   REF = cred$allele1,
                   ALT = cred$allele2,
                   QUAL = 100,
                   FILTER = ".",
                   INFO = "."
  )
  
  vcfname = paste0("vcfs/",names(snpsList[i]),".cred90.vcf")
  write.table(vcf,
              file = vcfname,
              sep = "\t",
              col.names = F,
              quote = F,
              row.names = F)
  
  cmd = paste("source annonate.sh",vcfname)
  system(cmd)
  
}


tmp = do.call(rbind,snpsList)

tmp[tmp$rsid == "rs2073711",]

