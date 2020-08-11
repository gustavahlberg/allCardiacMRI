#
# 
# Plot model results
# 
# -------------------------------------
#
# load
#

library(rethinking)
library(rafalib)
phenos = c('ilamax', 'ilamin', 'laaef', 'lapef', 'latef')
grid.lps = seq(from= -log10(1e-2), to = -log10(5e-08), by = exp(log(0.2))) 


# -------------------------------------
#
# run
# 

resList = list()

for(pheno in phenos) {
  print(pheno)

  resFile.fn <- sprintf("results/bootstraped_CTPrs_%s.rds",pheno)
  
  load(resFile.fn, verbose = T)
  bsResListMat <-  do.call(rbind, bsResList)
  
  bsRes <- split(bsResListMat, bsResListMat[,c("size","thr.r2")])
  bsRes <- bsRes[which(sapply(bsRes, dim)[1,] != 0)]
  
  # -------------------------------------
  #
  # Plot
  #
  
  plot.fn = sprintf("results/btCTplots_%s.tiff", pheno)
  resMat = matrix(NA, nrow = 16, ncol = 5, 
                  dimnames = list(c(),c("r2","ws","max.lps", "cor", "cor.se")))
  
  # plot 16 curves w/ se
  tiff(filename = plot.fn,
       width = 8, height = 8.5, 
       units = 'in',
       res = 300)
  
  mypar(a = 4, b = 4)
  for(i in 1:16) {
    #i = 15
    
    # title 
    x = names(bsRes[i])
    x = unlist(regmatches(x, regexpr("\\.", x), invert = TRUE))
    plottitle <- sprintf("window size: %s, r2: %s", x[1], x[2])
    bs = bsRes[[i]]
    bsTheLp <- split(bs,bs$thr.lp)
  
    bsMeans = sapply(bsTheLp, function(x) mean(x[,'cor']))
    seMeans <- sapply(bsTheLp, function(x) sd(x[,'cor'])/sqrt(1000))
    sapply(bsTheLp, function(x) sd(x[,'cor']))
    
    resMat[i, 'cor'] <- bsMeans[which.max(bsMeans)]
    resMat[i, 'cor.se'] <- seMeans[which.max(bsMeans)]
    resMat[i, 'max.lps'] <- names(bsMeans[which.max(bsMeans)])
    resMat[i, 'ws'] <- x[1]
    resMat[i, 'r2'] <- x[2]
    
  # seMeans <- sapply(bsTheLp, function(x) sd(x[,'cor'])/sqrt(1000))
  # plot(names(bsMeans), bsMeans, ylim = c(0,0.1), pch = 19,
  #      ylab = "correlation", xlab = "thrs. -log(p)")
  
    d <- data.frame(correlation = bs$cor, 
                    thrLp = bs$thr.lp,
                    thrLp2 = bs$thr.lp^2)
  
    #fit model
    mod <- map(
      alist(
        correlation ~ dnorm(mu, sigma),
        mu <- a + b1*thrLp + b2*thrLp2,
        a ~ dnorm(0.05,1),
        b1 ~ dnorm(0, 1),
        b2 ~ dnorm(0, 1),
        sigma ~ dunif(0, 10)
      ), data = d
    )
  
  #precis(mod)
    post <- extract.samples(mod)
    thrLp.seq <- seq(range(d$thrLp)[1], range(d$thrLp)[2], by = 0.01)
    mu <- link(mod, data = list(thrLp = thrLp.seq, thrLp2 = thrLp.seq^2)) 
    mu.mean <- apply(X = mu, MARGIN = 2, FUN = mean)
    mu.PI <- apply(X = mu, MARGIN = 2, FUN = PI, prob = .95)
    
    
    
    sim.cor <- sim(mod, data = list(thrLp = thrLp.seq, thrLp2 = thrLp.seq^2), n = 1e3)
    cor.PI <- apply(X = sim.cor, MARGIN = 2, FUN = PI, prob = .95)
    
    idx = sample(seq(dim(d)[1]), size = 3000, replace = F)
    
    plot(correlation ~ thrLp, data = d[idx,], 
         ylim = c(0,0.1), 
         col = col.alpha(rangi2,0.1),
         main = plottitle, cex = 0.8)
    lines(x = thrLp.seq, y = mu.mean, lwd = 2)
    shade(cor.PI, thrLp.seq)
  }

  resList[[pheno]] <- resMat
  dev.off()

}

# -------------------------------------
#
# pick best model
#

tiff(filename = "max_correlation_tier.tiff",
     width = 8, height = 8.5, 
     units = 'in',
     res = 300)


mypar(a = 3, b = 2, mar=c(7, 4.1, 4.1, 2.1))
for(pheno in phenos) {

  tab = resList[[pheno]]
  xlab = paste(tab[,'ws'],tab[,'r2'], tab[,'max.lps'], sep = "_")
  
  plot(tab[,'cor'], pch = 19, ylab = 'correlation',
       main = pheno, xlab = "", xaxt = "n")
  axis(1, at=1:16, labels= xlab, las= 2, cex = 0.5)
  
  for(i in 1:16) {
    lines(c(i,i), c(as.numeric(tab[i,'cor']) - 2*as.numeric(tab[i,'cor.se']),
                    as.numeric(tab[i,'cor']) + 2*as.numeric(tab[i,'cor.se'])))
  }

}

dev.off()



# -------------------------------------
#
# pick best model
#

bestCT = matrix(NA, nrow = 5, ncol = 9, dimnames = list(c('ilamax', 'ilamin', 'laaef', 'lapef', 'latef'),
c("size","thr.r2","grp.num","thr.imp","thr.lp","num","snpsize","cor","cor.se")))
phenos = c('ilamax', 'ilamin', 'laaef', 'lapef', 'latef')

for(i in 1:length(phenos)) {
  #i = 1
  pheno = phenos[i]
  resFile.fn <- sprintf("results/bootstraped_CTPrs_%s.rds",pheno)
  load(resFile.fn, verbose = T)
  grid2 = read.table(sprintf("results/grid_%s.tab", pheno),
                     stringsAsFactors = F,
                     header = T)
  grid2$cor <- NA
  grid2$cor.se <- NA
  bsResListMat <-  do.call(rbind, bsResList)


  for(j in 1:nrow(grid2)) {
    #print(grid2[j,])
    tmp = bsResListMat[bsResListMat$size ==  grid2[j,'size'] & 
                         bsResListMat$thr.r2 ==  grid2[j,'thr.r2'] &
                         bsResListMat$thr.lp ==  grid2[j,'thr.lp'] ,
                       ]
    #tmp = split(tmp, tmp$thr.lp)
    grid2[j,"cor"] <- mean(tmp$cor)
    grid2[j,"cor.se"] <- sd(tmp$cor)/sqrt(nrow(tmp))
  }

  grid2 = grid2[-which(rowSums(is.na(grid2)) > 0),]
  grid2[order(grid2$cor, decreasing = T),]

  maxRes = grid2[which.max(grid2$cor),]

  canditates = grid2[grid2$cor >= (maxRes$cor - 2*maxRes$cor.se),]
  bestCT[i,] <- as.matrix(canditates[which.min(canditates$snpsize),])

}


write.table(bestCT,
            file = "results/bestCT_models_200811.tsv",
            quote = F,
            sep = "\t",
            col.names = T,
            row.names = T
            )

###############################
# EOF # EOF # EOF # EOF # EOF #
###############################

