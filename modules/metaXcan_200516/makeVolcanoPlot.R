# 
#
# make volcano plot
#
# ---------------------------------------------------------
#
# load table
#

#file = files[3]
results = read.csv(file)

#dim()

# ---------------------------------------------------------
#
# plot
#

# library(qvalue)
# p = results$pvalue
# qobj <- qvalue(p, fdr.level=0.05, pi0.method="bootstrap", adj=1.2)
#p.adjust(results$pvalue, method = "fdr", n = length(results$pvalue))

bonferroni = -log10(0.05/dim(results)[1])
colVec = rep('grey', dim(results)[1])
colVec[bonferroni < -log10(results$pvalue) & results$effect_size < 0] <- alpha('blue', 0.8)
colVec[bonferroni < -log10(results$pvalue) & results$effect_size > 0] <- 'red'

plot(results$effect_size, -log10(results$pvalue),
     pch = 19,
     col = colVec,
     cex = 0.7,
     xlim = c(-4,4),
     ylim = c(0,12),
     xlab = "Effect size",
     ylab = expression("-log"[10]*"(P)"),
     #main = gsub("_"," ",gsub(".txt","",basename(file))),
     main = title,
     cex.main = 1.2,
     bty = 'n',
     las = 2,
     xaxt = "n",
     yaxt = "n"
)


axis(1, at = c(-4,-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3,3.5,4),
     labels = c(-4,NA ,-3,NA,-2,NA,-1,NA,0,NA,1,NA,2,NA,3,NA,4),
     tick = TRUE, 
     las = 1,
     cex.axis = 0.85)


axis(2, at = c(0,2,4,6,8,10,12),
     labels = c("",2,"",6,"",10,""),
     tick = TRUE, 
     las = 1,
     cex.axis = 0.85)

abline(h = bonferroni, lwd= 0.7, lty = 2, col = 'grey')
#xlab =expression("Genetic correlation ("*italic(r)['g']*")")


resSign = results[which(colVec == "red" | colVec == alpha('blue', 0.8)),]
resSign = resSign[order(resSign$effect_size),]

if(dim(resSign)[1] >= 1) {
  flag = 0
  for( i in 1:dim(resSign)[1]) {
    #print(i)
    xoff = c(1, -0.6)
    yextra = 0
    
    if(i == dim(resSign)[1]) {
      flag = 1
      if(resSign$effect_size[i] > 3.5){
        xoff = xoff[2]
      }
      if(resSign$effect_size[i] <= 3.5){
        xoff = xoff[1]
      }
      
    }
    
    
    if(i < dim(resSign)[1]) {
      if(abs(resSign$effect_size[i] - resSign$effect_size[i + 1]) < 0.1 &
         abs(-log10(resSign$pvalue[i]) - -log10(resSign$pvalue[i + 1])) < 1.5) {
        flag = 1
        xoff = xoff[2]
        yextra = yextra + 0.5
        resSign$effect_size[i] - 0.2
        
      }
    }
    if(i > 1) {
      if(abs(resSign$effect_size[i] - resSign$effect_size[i - 1]) < 0.1 &
         abs(-log10(resSign$pvalue[i]) - -log10(resSign$pvalue[i - 1])) < 1.5){
        flag = 1
        xoff = xoff[1]
        yextra = yextra + 1.7
      }
    }
    
    
    if(flag == 1) {
      text(resSign$effect_size[i] + xoff,
           -log10(resSign$pvalue[i]) + 0.5 + yextra,
           as.character(resSign$gene_name[i]), col='black', offset=0, adj=c(0.5,-1), cex=.5)
      
      lines(c(resSign$effect_size[i] , resSign$effect_size[i] + xoff),
            c(-log10(resSign$pvalue[i])+0.009,-log10(resSign$pvalue[i]) + 0.5 + yextra),
            col = alpha("black", 0.4), lwd = 0.7)
    }
    
    if(flag == 0) {
      xoff =  0
      if(i < dim(resSign)[1]) {
        if(abs(resSign$effect_size[i] - resSign$effect_size[i + 1]) < 0.5 ) {
          xoff = -0.7
        }
      }
      if(i > 1) {
        if(abs(resSign$effect_size[i] - resSign$effect_size[i - 1]) < 0.5 ) {
          xoff = 0.1
        }
      }
      
      print(xoff)
      text(resSign$effect_size[i] + xoff + 0.1,
           -log10(resSign$pvalue[i]) + 0.5 ,
           as.character(resSign$gene_name[i]), col='black',  offset=0, adj=c(0, 1) , cex=.5,
           )
      
      
    }
    

    flag = 0
  
  }

}



#dev.off()

# ---------------------------------------------------------
#
# print table
#



# write.xlsx(x = results[results$pvalue <= 0.05, -9],
#            file = "results/MetaXcan_191202.xlsx",
#            append = TRUE,
#            row.names = F,
#            sheetName = paste(basename(file),"Nominal Signifcant transcriptome-wide results")
# )



#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################

