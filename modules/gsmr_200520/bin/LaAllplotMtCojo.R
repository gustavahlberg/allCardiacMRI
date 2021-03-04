#
#
# mtcojo function plot 
#
# ---------------------------------------------------

library(rafalib)
library(rethinking)

mtCojoTabAll = mtCojoTab[!mtCojoTab$pheno %in% c("LAmin","LAmax"),]
mtCojoTabAll$pheno = gsub("^i","", mtCojoTabAll$pheno)

mtCojoListAll = split(mtCojoTabAll, mtCojoTabAll$SNP)

lenRsids = do.call(rbind,(lapply(mtCojoListAll, dim)))[,1]

idx = unlist(sapply(1:length(lenRsids) ,function(i) 1:lenRsids[i] + cumsum(lenRsids+1)[i] - (lenRsids[i]+1) ))
xlab = "Beta (1/SD)"

cols = c("#33a02c", "#6a3d9a", "#ff7f00")
table = mtCojoTabAll
table$col = NA
table$col[table$condPheno == "AF"] <- cols[1]
table$col[table$condPheno == "HF"] <- cols[2]
table$col[table$condPheno == "None"] <- cols[3]


# ------------------------------------------
#
# plt start 
#


tiff(filename = "LAall_conditionalAnalysis.tiff",
     width = 9, height = 9.5, 
     units = 'in',
     res = 300)


mypar(mar = c(4,0.5,3,1))
plot(mtCojoTabAll$b, as.vector(idx) ,
     type = 'n',
     xlim = c(-0.3,0.3), 
     cex = 1,
     xlab = "",
     ylab = "",
     col = "black",
     bty = 'n',
     yaxt = "n",
     xaxt = "n"
)


axis(1, at = c(-0.1,-0.05, 0,0.05, 0.1,0.15 ,0.2,0.25,0.3),
     labels = c(-0.1,-0.05, 0,0.05, 0.1,0.15,0.2,0.25,0.3), 
     tick = TRUE, 
     las = 1,
     cex.axis = 0.85)

axis(1, at = c(-0.2,-0.1),
     labels = FALSE, 
     tick = TRUE, 
     las = 1,
     lwd.ticks = 0)

abline(v = 0, col = alpha('black', 0.4))
abline(v = -0.1, col = alpha('black', 0.05))
abline(v = -0.05, col = alpha('black', 0.05))
abline(v = 0, col = alpha('black', 0.05))
abline(v = 0.05, col = alpha('black', 0.05))
abline(v = 0.1, col = alpha('black', 0.05))
abline(v = 0.15, col = alpha('black', 0.05))


title(xlab=xlab, line = 2.3, adj = 0.5)


for(k in 1:nrow(table)) {
  #k = 1
  j = k
  i = as.vector(idx)[k]
  
  # 95 % CI 
  lines(c(table$b[j] - table$se[j], table$b[j] + table$se[j]), rep(i,2),
        lwd =2.5, col = table$col[j])
  
  lines(c(table$b[j] - 1.96*table$se[j], table$b[j] + 1.96*table$se[j]), rep(i,2),
        lwd =1, col = table$col[j])
  
  points(table$b[j],i, pch = 16, cex = 1.1, col = table$col[j])
  
  
  tmp = format(signif(table$p[j],1), scientific = FALSE)
  if(tmp == 1) {
    num =  tmp
    name = paste(table$p1[j],"vs" ,table$p2[j])
    poly = 0
  } else {
    t = unlist(strsplit(split = "",tmp))
    ans = which(t != 0)
    poly = 2 - ans[2] 
    num =  t[ans[2]]
    name = paste(table$SNP[j]," in ", table$pheno[j])
  }
  
  text(-0.1,i, bquote( .(name) ~ "(P ="~.(num)~x~10^.(poly) *")"), 
       cex = 0.75, adj = c(1,0.3) )
  
  
}


mypar(xpd = T,mar = c(2,0.5,0,1))
legend(0.15, 68,
       c("AF adjusted","HF adjusted","Unadjusted"),
       cex = 1.1,
       col = cols,
       pch = 16,
       bty = "n",
       ncol = 1,
       pt.cex = 1.7,
       text.width = 0.1
)


dev.off()






