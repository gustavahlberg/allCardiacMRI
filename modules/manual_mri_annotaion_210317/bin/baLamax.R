#
#
# Bland altmans plots for LAmax
#
#
#  -----------------------------------------------------------------

png("LAmax_blandAltman_210416.png",
    width=16,height=9,res=300,units="in")

par(mfrow=c(1,2))

df <- interRes
df <- df[!is.na(df$Biplane_LAmax),]
A <- df$LAV.max..mL.
B <- as.numeric(df$Biplane_LAmax)
col <- rep(brewer.pal("Paired",n=4)[1], dim(df)[1])
col[df$included == 0 ] <- brewer.pal("Paired",n=10)[5]


idxFiltered <- which(df$LAV.max..mL. < lamax_range[1] |
                       df$LAV.max..mL. > lamax_range[2])
col[idxFiltered ] <- 'red'


d1 <- data.frame(A,B)
d1 <- d1[df$included == 1,]
min(d1$A)

m1 <- ulam(
  alist(B ~ dnorm(mu, sigma),
        mu <- a + b*A,
        a ~ dnorm(30, 20),
        b ~ dnorm(0,10),
        sigma ~ dunif(0,10)
  ),
  data = list(A= d1$A, B= d1$B), 
  chains = 1, 
  cores = 1, 
  warmup = 500,
  iter = 4000
  
)


precis(m1)

a_seq <- seq(from = 0, to = max(A) + 10, length.out = 200)
l <- link(m1 , data = list(A = a_seq), n = 1e4)
s <- sim(m1 , data = list(A = a_seq), n = 1e4)
mu <- apply(l,2, mean)
mu.ci <- apply(l,2, PI, prob = 0.95)
a.ci <- apply(s,2, PI, prob = 0.95)

plot(B ~ A, col = "black", bg = col, pch = 21, xlim = c(0, 10+max(A)),
     xlab = "Automatic LAmax (mL)",
     ylab = "Manual LAmax (mL)")
lines(a_seq, mu)
shade(a.ci, a_seq)
shade(mu.ci, a_seq)
abline( v = lamax_range[1], lty = 2)
abline( v = lamax_range[2], lty = 2)


# ---------------------------------------------
#
# Blnad altman plot
#

plot((df$LAV.max..mL. + df$Biplane_LAmax)/2, 
     df$LAV.max..mL. - df$Biplane_LAmax,
     bg = col, pch = 21, xlim = c(0, 10+max(A)),
     xlab = "Average of automated and manual (mL)",
     ylab = "diff. Auto - Manual (mL)"
     #type = 'n'
)

abline(h = mean(d1$A -d1$B ))
upper <- mean(d1$A -d1$B ) + 1.96*sd(d1$A -d1$B )
lower <- mean(d1$A -d1$B ) - 1.96*sd(d1$A -d1$B )
abline(h = upper, lty = 2)
abline(h = lower, lty = 2)



dev.off()

cor(d1$A, d1$B, method = 'pearson')
s1 <- sim(m1)
r <-  apply(s1,2,mean) - d1$B
resid_var <- var2(r)
o_var <- var2(d1$B)
r2 <- 1 -  resid_var/o_var

