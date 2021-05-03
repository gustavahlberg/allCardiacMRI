# ---------------------------------------------
#
# Plot histograms
#
# ---------------------------------------------


dim(allTab)

sum(!is.na(allTab$rntrn_ilamax))
df <- allTab[(!is.na(allTab$rntrn_ilamax)),]


phenos = c("ilamax", "ilamin", "laaef", "lapef", "latef")
names = c("LAmax", "LAmin", "LAAEF", "LAPEF", "LATEF")

png("histogramPheno_210414.png",
    width=13,height=18,res=300,units="in")
#par(mfrow=c(5,2), mar = c(3,10,5,2))
par(mfrow=c(5,2), mar = c(7,5,1,2))

for(i in 1:5){
  pheno = phenos[i]
  name = names[i]
  
  var = df[,pheno]
  varR = df[, paste0("rntrn_", pheno)]
  
  hist(var, breaks = 40, 
     col = brewer.pal("Paired",n=4)[1],
     ylab = "N individuals",
     xlab = name,
     xlim = c(min(var,na.rm = T)-10, max(var, na.rm = T) + 10),
     main = "",
     cex.lab=2.2,
     cex.axis=1.5
     )

  hist(varR, breaks = 40, 
     col = brewer.pal("Paired",n=10)[5],
     ylab = "N individuals",
     xlab = paste("INT", name),
     xlim = c(min(varR,na.rm = T)-1, max(varR, na.rm = T) + 1),
     main = "",
     cex.lab=2.2,
     cex.axis=1.5
     
  )

}

dev.off()


summary(df$latef)
summary(df$ilamax)







#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################

c1 <- rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue")
c2 <- rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink")


hg1 <-hist(allTab$rntrn_laaef[allTab$sex == 1], col = brewer.pal("Paired",n=4)[1],
           plot = FALSE)
hg2 <-hist(allTab$rntrn_laaef[allTab$sex == 2], col = brewer.pal("Paired",n=4)[1],
           plot = FALSE)
plot(hg1, col = c1)
plot(hg2, col = c2, add = TRUE)

