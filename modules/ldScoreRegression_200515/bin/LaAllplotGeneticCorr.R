# ---------------------------------------------------
#
# La function plot 
#
# ---------------------------------------------------


genCorAll = genCor[c("ilamax",'ilamin',"laaef","lapef","latef")]

table = do.call(rbind, genCorAll)
table$p1 = toupper(table$p1)
table$p1[table$p1 == "ILAMAX"] <- "LAmax"
table$p1[table$p1 == "ILAMIN"] <- "LAmin"

# subset
table = table[-which(table$p2 == "Type II diabetes" | table$p2 == "Health rating"),]

#table$signGroup = ifelse(table$p >= 0.05, 'gray60', ifelse(table$p*nrow(table) >= 0.05,3, 1))
table$signGroup = ifelse(table$p >= 0.05, 'gray60', 1)

table$p1 = gsub(".unadj","",table$p1)
idx = sapply(seq(0,length.out = 8, by = 6) ,function(i) (1:5 + i))

idx = as.vector(idx)

xlab =expression("Genetic correlation ("*italic(r)['g']*")")
mypar(mar = c(4,0.5,3,1))
o = order(table$p2,decreasing = T)

tiff(filename = "LaAll_GeneticCorrelation_200731.tiff",
     width = 9, height = 8.5, 
     units = 'in',
     res = 300)


plot(table$rg[o], as.vector(idx) ,
     type = 'n',
     xlim = c(-1.7,1), 
     cex = 1,
     xlab = "",
     ylab = "",
     col = "black",
     bty = 'n',
     yaxt = "n",
     xaxt = "n"
)

axis(1, at = c(-0.5,-0.25, 0,0.25, 0.5,0.75,1.0),
     labels = c(-0.5,-0.25,0 ,0.25,0.5,0.75,1.0), 
     tick = TRUE, 
     las = 1,
     cex.axis = 0.85)
axis(1, at = c(-0.6,-0.5),
     labels = FALSE, 
     tick = TRUE, 
     las = 1,
     lwd.ticks = 0)


abline(v = 0, col = alpha('black', 0.4))
abline(v = -0.25, col = alpha('black', 0.05))
abline(v = 0.25, col = alpha('black', 0.05))
abline(v = 0.5, col = alpha('black', 0.05))
abline(v = 0.75, col = alpha('black', 0.05))
abline(v = -0.5, col = alpha('black', 0.05))
abline(v = 1, col = alpha('black', 0.05))
title(xlab=xlab, line = 2.3, adj = 0.7)



for(k in 1:nrow(table)) {
  j = o[k]
  i = as.vector(idx)[k]
  
  
  # SE
  lines(c(table$rg[j] - table$se[j], table$rg[j] + table$se[j]), rep(i,2),
        lwd =2.5, col = table$signGroup[j])
  
  # CI of SE
  lines(c(table$rg[j] - 1.96*table$se[j], table$rg[j] - table$se[j]), 
        rep(i,2), lwd =1, col = alpha('black', 0.4))
  lines(c(table$rg[j] + table$se[j], table$rg[j] + 1.96*table$se[j]), 
        rep(i,2), lwd =1, col = alpha('black', 0.4))
  
  # rg mean
  #if(i %in% c(1,5,9,13,17,21,25))
  points(table$rg[j],i, pch = 16, cex = 1.1, col = table$signGroup[j])
  #if(i %in% c(2,6,10,14,18,22,26))
  #  points(table$rg[j],i, pch = 16, cex = 1.1, col = table$signGroup[j])
  #if(i %in% c(3,7,11,15,19,23,27))
  #  points(table$rg[j],i, pch = 16, cex = 1.1, col = table$signGroup[j])
  
  
  #text(-0.55,i, labels = table$p2[j], cex = 0.7, adj = c(1,NA))
  
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
    name = paste(table$p1[j],"vs" ,table$p2[j])
  }
  
  text(-0.8,i, bquote( .(name) ~ "(P ="~.(num)~x~10^.(poly) *")"), 
       cex = 0.75, adj = c(1,0.3) )
  
  
}


mypar(xpd = T,mar = c(4,0.5,3,1))
legend(-0.35, 50,
       c("P > 0.05","P < 0.05"),
       cex = 0.85,
       col = c('gray60',1),
       pch = 16,
       bty = "n",
       ncol = 3,
       pt.cex = 1.3,
       text.width = 0.35
)


# legend(-0.5, 49,
#        c("P > 0.05","P < 0.05", "Bonf. adj. P < 0.05"),
#        cex = 0.85,
#        col = c('gray60', 3,1),
#        pch = 16, 
#        bty = "n",
#        ncol = 3,
#        pt.cex = 1.2,
#        text.width = 0.35
# )

mypar(mar = c(4,0.5,3,1))

dev.off()