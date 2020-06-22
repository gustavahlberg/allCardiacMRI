#
# function GWAS_Manhattan 
# usage, plotting manhattan plot
#
# ------------------------------------------------------

GWAS_Manhattan <- function(GWAS, loci, col.snps=c("black","gray"),
                           col.sign=c("deepskyblue"), col.imputed=c("black"), col.text="black",
                           title="", display.text=TRUE,
                           bonferroni.alpha=0.05, 
                           bonferroni.adjustment=1000000,
                           Lstringent.adjustment=10000,
                           add.legend = TRUE) {
  
  bonferroni.thresh <- -log10(bonferroni.alpha / bonferroni.adjustment)
  Lstringent.thresh <- -log10(bonferroni.alpha / Lstringent.adjustment)
  xscale <- 1000000
  
  loci = loci[order(as.numeric(loci$chr),as.numeric(loci$bp)),]
  loci$Neg_logP = -log10(as.numeric(loci$sent_pval))

  
  manhat <- GWAS[!grepl("[A-z]",GWAS$CHR),]
  
  #sort the data by chromosome and then location
  manhat.ord <- manhat[order(as.numeric(manhat$CHR),manhat$BP),]
  manhat.ord <- manhat.ord[!is.na(manhat.ord$BP),]
  
  ##Finding the maximum position for each chromosome
  max.pos <- sapply(1:21, function(i) { max(manhat.ord$BP[manhat.ord$CHR==i],0) })
  max.pos2 <- c(0, cumsum(max.pos))
  
  #Add spacing between chromosomes
  max.pos2 <- max.pos2 + c(0:21) * xscale * 10
  
  #defining the positions of each snp in the plot
  manhat.ord$BP.2 <- manhat.ord$BP 
  manhat.ord$BP <- manhat.ord$BP + max.pos2[as.numeric(manhat.ord$CHR)]
  loci$BPscale =  as.numeric(loci$bp) + max.pos2[as.numeric(loci$chr)]
  
  # alternate coloring of chromosomes
  manhat.ord$col <- col.snps[1 + as.numeric(manhat.ord$CHR) %% 2]
  
  # draw the chromosome label roughly in the middle of each chromosome band
  text.pos <- sapply(c(1:22), function(i) { mean(manhat.ord$BP[manhat.ord$CHR==i]) })
  
  
  # significant snps
  SigNifSNPs <- as.character(manhat.ord[manhat.ord$Neg_logP >= bonferroni.thresh , "SNP"])
  
  manhat.ord.sign = manhat.ord[manhat.ord$SNP %in% SigNifSNPs,]
  manhat.ord.sign.split = split(manhat.ord.sign, manhat.ord.sign$CHR)
  #sentinels = matrix(,nrow = 0 , ncol = ncol(manhat.ord))
  colnames(sentinels) = colnames(manhat.ord)
  
  for(i in 1:length(loci)) {
    locus =loci[i,]
    manhat.ord$type[manhat.ord$CHR %in% locus$chr  & manhat.ord$BP.2 > as.numeric(locus$bp)-500000 & 
                      manhat.ord$BP.2 < as.numeric(locus$bp)+500000] <- "sign" 
  }
  
  
  #V ...

  # Plot the data
  ylabel = expression("-log"[10]*"(P)")
  plot(manhat.ord$BP[manhat.ord$type=="typed"]/xscale, manhat.ord$Neg_logP[manhat.ord$type=="typed"],
       pch=20, cex=.3, col= manhat.ord$col[manhat.ord$type=="typed"], xlab=NA,
       ylab=ylabel, axes=F, ylim=c(0,max(manhat$Neg_logP)+1.5), 
       xlim = c(0, max(manhat.ord$BP[manhat.ord$type=="typed"]/xscale) + 40))
      #Add x-label so that it is close to axis
  mtext(side = 1, "Chromosome", line = 1.25)
  
    
    
  #points(manhat.ord$pos[manhat.ord$type=="imputed"]/xscale, manhat.ord$Neg_logP[manhat.ord$type=="imputed"],
  #       pch=20, cex=.4, col = col.imputed)
  #points(manhat.ord$pos[manhat.ord$type=="typed"]/xscale, manhat.ord$Neg_logP[manhat.ord$type=="typed"],
  #       pch=20, cex=.3, col = manhat.ord$col[manhat.ord$type=="typed"])

  axis(2)
  abline(h=0)
  
  #SigNifSNPs <- as.character(GWAS[GWAS$Neg_logP > Lstringent.thresh & GWAS$type=="typed", "SNP"])
  #Add legend
  
  if(add.legend == TRUE) {
  legend("topright",c("Bonferroni corrected threshold (p = 5E-8)", "Candidate threshold (p = 5E-6)"),
         border="black", col=c("gray60", "gray60"), pch=c(0, 0), lwd=c(1,1),
         lty=c(1,2), pt.cex=c(0,0), bty="o", cex=0.6)
  }
  #Add chromosome number
  text(text.pos/xscale, -.4, seq(1,22,by=1), xpd=TRUE, cex=.75)
  #Add bonferroni line
  abline(h=bonferroni.thresh, untf = FALSE, col = "gray60", lty = 1)
  #Add "less stringent" line
  abline(h=Lstringent.thresh, untf = FALSE, col = "gray60", lty = 2 )
  
  
  # nearest gene
  nearstGenes = do.call(rbind,apply(loci, 1, function(sen) nearest_gene(sen, genelist)))


  
  #Plotting sign genes
  #Were any genes sign?
  if (length(SigNifSNPs)>0){
     sig.snps <- manhat.ord[,'SNP'] %in% SigNifSNPs
     
    points(manhat.ord$BP[manhat.ord$type=="sign"]/xscale,
           manhat.ord$Neg_logP[manhat.ord$type=="sign"],
           pch=20,col=col.sign, bg=col.sign,cex=0.5)

    # plot(manhat.ord$POS[manhat.ord$type=="sign"]/xscale,
    #        manhat.ord$Neg_logP[manhat.ord$type=="sign"],
    #        pch=20,col=col.sign, bg=col.sign,cex=0.5)
    
    
    for( i in 1:dim(loci)[1]) {
      #print(i)
      xoff = c(-80, 100)
      if (i == 1) {
        j = i 
      } else {j = j + 1}
      
      if( i > 1 ){
        if(loci$chr[i] == loci$chr[i-1]){
           j = j - 1   
        }
        if(i < dim(loci)[1]){
          if(loci$BPscale[i+1] - loci$BPscale[i] < 100e6){
            j = j - 1   
          }
        }
        
      }
      
      if(nearstGenes$GENE[i] == "PLEKHA3") {
        nearstGenes$GENE[i] = "TTN"
      }
      print(xoff[ifelse(j %% 2 == 0,2,1)])
      text(loci$BPscale[i]/xscale + xoff[ifelse(j %% 2 == 0,2,1)],
          loci$Neg_logP[i] + 0.5,
          as.character(nearstGenes$GENE[i]), col=col.text, offset=0, adj=c(0.5,-1), cex=.7)
      
      lines(c(loci$BPscale[i]/xscale + 5,loci$BPscale[i]/xscale + xoff[ifelse(j %% 2 == 0,2,1)]),
           c(loci$Neg_logP[i]+0.05, loci$Neg_logP[i] + 0.4))
      
    }
  }

}

