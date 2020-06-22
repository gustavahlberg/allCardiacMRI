#
# loadData
#
# -------------------------------
#
# load
#


snps.fns = list.files("output", full.names = T, pattern = ".snp$")
cred.fns = list.files("output", full.names = T, pattern = ".cred1$")

snpsList = list()
credList = list()


for(i in 1:length(snps.fns)) {
  #i = 11
  #snps
  snps.fn = snps.fns[i]
  nameSnp = gsub(".snp","", basename(snps.fn))
  snps = read.table(snps.fn,
                    stringsAsFactors = F,
                    header = T)

  snpsbf2 = snps[snps$log10bf > 2,]
  snpsList[[nameSnp]] <- snpsbf2


  #cred
  cred.fn = cred.fns[i]
  cmd = paste("head -1", cred.fn, '| cut -f 9 -d " "')
  if(system(cmd,intern = T) < 0.5) {
    print(i)
    cred.fn = gsub("1$","2",cred.fn)
    cred = read.table(cred.fn,
                      stringsAsFactors = F,
                      header = T)
    
    cred = cred[1:(sum(cumsum(cred$prob2) < 0.9) + 1),]
    rsid = unique(c(cred$cred1, cred$cred2))
    
  } else{ 
    cred = read.table(cred.fn,
    stringsAsFactors = F,
    header = T)
    cred = cred[1:(sum(cumsum(cred$prob1) < 0.9) + 1),]
    rsid = unique(cred$cred1)
    
  }
  
  rsid = rsid[!is.na(rsid)]
  credList[[nameSnp]] <- snps[which(snps$rsid %in% rsid),]
  
}



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # 
###########################################

