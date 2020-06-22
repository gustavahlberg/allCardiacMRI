colocList = list()
runtissue = tissues[["Heart_Atrial_Appendage"]]


for(i in 1:length(loci)) {
  
  #locus = loci$rntrn_ilamax_1.chr1
  nameslocus = names(loci[i])
  locus = loci[[i]]
  locus$variant_id_b37 <- NA
  
  snpA1A2 = paste(locus$chromosome, locus$position, locus$allele1, locus$allele2, sep = "_")
  snpA2A1 = paste(locus$chromosome, locus$position, locus$allele2, locus$allele1, sep = "_")
  
  
  idxSnpA1A2 = which(snpA1A2 %in% gsub("_b37","",lookupMatch$variant_id_b37))
  idxSnpA2A1 = which(snpA2A1 %in% gsub("_b37","",lookupMatch$variant_id_b37))
  idxSnpA2A1 = idxSnpA2A1[-which(idxSnpA2A1 %in% idxSnpA1A2)]
  
  locus$variant_id_b37[idxSnpA1A2] <- paste0(snpA1A2[idxSnpA1A2],"_b37")
  locus$variant_id_b37[idxSnpA2A1] <- paste0(snpA2A1[idxSnpA2A1],"_b37")
  
  locus = locus[sort(unique(c(idxSnpA2A1,idxSnpA1A2))),]
  
  
  # eqtls
  varInLocusb38 = lookupMatch$variant_id[which(lookupMatch$variant_id_b37 %in% locus$variant_id_b37)]
  runtissueLocus = runtissue[runtissue$variant_id %in% varInLocusb38,]
  
  runtissueLocus$variant_id_b37 <- sapply(runtissueLocus$variant_id, function(x) {  
    lookupMatch$variant_id_b37[lookupMatch$variant_id == x]
  })
  
  
  runtissueLocusGenes = split(runtissueLocus, runtissueLocus$gene_id)
  if(length(runtissueLocusGenes) < 1) {
    next
  }
  
  locusGene = list()  
  for(j in 1:length(runtissueLocusGenes)){ 

    runtissueLocusGene = runtissueLocusGenes[[j]]
    geneName = names(runtissueLocusGenes[j])
    # merge
    input <- merge(runtissueLocusGene, locus, by="variant_id_b37", all=FALSE, suffixes=c("_eqtl","_gwas"))
    # run
    result <- coloc.abf(dataset1=list(beta=input$beta, 
                                      varbeta = input$se^2,
                                      type="quant",
                                      sdY = 1,
                                      MAF = input$maf_gwas),
                        dataset2=list(pvalues=input$pval_nominal,
                                      type="quant", 
                                      N = 372, 
                                      MAF=input$maf_eqtl)
    )
    
  
    H4 = result$summary[6] 
    if (H4 > H4thres ) {
      
      resTab = result$results[order(result$results$SNP.PP.H4,decreasing = T),]
      resTab95 = resTab[1:(sum(cumsum(resTab$SNP.PP.H4) <= 0.95) + 1),]
      locusSubSet = locus[locus$variant_id_b37 %in% input[as.numeric(gsub("SNP\\.","",resTab95$snp)),]$variant_id_b37,]
      
      locusSubSet = locus[match(input[as.numeric(gsub("SNP\\.","",resTab95$snp)),]$variant_id_b37,locus$variant_id_b37),]
      
      
      head(locus[match(input[as.numeric(gsub("SNP\\.","",resTab95$snp)),]$variant_id_b37,locus$variant_id_b37),])
      input[as.numeric(gsub("SNP\\.","",resTab95$snp)),]
      
      snpinfo = data.frame(rsid = locusSubSet$rsid,
                           chr = locusSubSet$chromosome,
                           pos = locusSubSet$position,
                           ppH4 = resTab95$SNP.PP.H4,
                           pval_eqtl = resTab95$pvalues.df2,
                           pval_gwas = locusSubSet$pval)
      
      result[['top95snpinfo']] <- snpinfo
      locusGene[[geneName]] <- result
      
      # run locuscompare
      write.table(data.frame(rsid = input$rsid, pval = input$pval),
                  file = "tmpgwas.tab", quote = F, row.names = F, col.names = T)
      write.table(data.frame(rsid = input$rsid, pval = input$pval_nominal),
                  file = "tmpeqtl.tab", quote = F, row.names = F, col.names = T)
      
      #plot(input$pval,  input$pval_nominal)
      #tiff(filename = paste0("locusCompare/",nameslocus,"_",geneName,".tiff"), width = 8, height = 6,units = "in", res = 400)
      # locuscompare(in_fn1 = "tmpgwas.tab", 
      #              in_fn2 = "tmpeqtl.tab", 
      #              title1 = gsub("rntrn_|_[1-9]\\.chr\\d+","",nameslocus),
      #              title2 = 'Atrial appendage eQTL'
      #              #title2 = paste(geneName,'Atrial appendage eQTL')
      # )
      #dev.off()
      
    }
  }
  
  if(length(locusGene) > 0){
    colocList[[nameslocus]] <- locusGene
  }
}

aaColocList = colocList


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################