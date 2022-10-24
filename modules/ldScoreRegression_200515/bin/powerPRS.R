#
# Power calc for: 
# PRS PCSK9 inhibition and heart failure
#
# 
#----------------------------------------------

R <- seq(from = 0.0001, to = 0.03,
         length.out = 100)
u = 1

N <- sapply(R, function(r)
  pwr.f2.test(u = 2, f2 = r/(1 - r), 
              sig.level = 0.05/14, 
              power = 0.8)$v)
       


r/(1 - r)

#----------------------------------------------
#
# plot
#

#dev.off()

plot(R, N, type = 'n',
     xlim = c(0,0.01),
     ylim = c(0,100000),
     bty = 'n',
     xlab = "R2",
     ylab = "",
     yaxt = "n",
     xaxt = "n")

axis(1, at = seq(0, 0.01, 0.001),
     labels = seq(0, 0.01, 0.001), 
     tick = TRUE, 
     las = 1,
     cex.axis = 0.85)

axis(2, at = seq(0, 100000, by = 10000),
     labels = paste0(seq(0, 100, by = 10),"K"), 
     tick = TRUE, 
     las = 1,
     lwd.ticks = 0.5,
     cex.axis = 0.85)

abline(h = 35000, col = alpha('black', 0.1), 
       lwd=3, lty = 2 )
lines(R, N, col = alpha('blue', 0.4), lwd =3)

title(main = "PRS 80% power", cex.main = 0.85)



#----------------------------------------------






