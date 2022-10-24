#
#
# Outlier logistic regression
#
#
# -----------------------------------------------------------------
#
# Load
#

df <- interRes
df <- df[!(is.na(df$Biplane_LAmax) | is.na(df$Biplane_LAmax)),]

primAnInFn <- "../../../cardiacMRI/modules/extrct_atrialVol_200106/results/table_atrial_annotations_all.csv"
repAnInFn <- "../../../repCardiacMRI/modules/extrct_atrialVol_200225/results/rep_table_atrial_annotations_all.csv"

primAnIn = read.table(primAnInFn,
                      stringsAsFactors = F,
                      header = T,
                      sep = "\t")
repAnIn = read.table(repAnInFn,
                     stringsAsFactors = F,
                     header = T,
                     sep = "\t")

anIn <- rbind(primAnIn, repAnIn)

range(anIn$lamax); range(anIn$lamin)

laminDistribution <- ecdf(anIn$lamin)
lamaxDistribution <- ecdf(anIn$lamax)

idxBad <- grep("AF|AFLI|ch out of image plan", 
               df$Comment )

ytmp <- rep(0, dim(df)[1])
ytmp[idxBad] <- 1

df[idxBad,]$Comment
ytmp

y <- ytmp

# -----------------------------------------------------------------
#
# df 
#


lamin_dist <- laminDistribution(df$LAV.min..mL.) - 0.5
lamax_dist <- lamaxDistribution(df$LAV.max..mL.) - 0.5

eu_dist <- sapply(1:length(lamin_dist), function(i) {
  sqrt(lamin_dist[i]^2 + lamax_dist[i]^2)
})

summary(glm(y ~ eu_dist, family = binomial()))
summary(glm(ytmp ~ abs(lamax_dist), family = binomial()))
summary(glm(ytmp ~ abs(lamin_dist), family = binomial()))


# -----------------------------------------------------------------
#
# model
#


mlog_max <- ulam(
  alist(y ~ dbinom(1, p),
        logit(p) <-  a + b*x,
        a ~ dnorm(0, sigma),
        b ~ dnorm(0,tau),
        sigma ~ dnorm(0,10),
        tau ~ dexp(1)
  ),
  data = list(y = y, x = abs(lamax_dist)), 
  chains = 1, 
  cores = 1, 
  warmup = 1000,
  iter = 10000
  
)

mlog_min <- ulam(
  alist(y ~ dbinom(1, p),
        logit(p) <-  a + b*x,
        a ~ dnorm(0, sigma),
        b ~ dnorm(0,tau),
        sigma ~ dnorm(0,10),
        tau ~ dexp(1)
  ),
  data = list(y = y, x = abs(lamin_dist)), 
  chains = 1, 
  cores = 1, 
  warmup = 1000,
  iter = 10000
  
)


idxBad <- grep("AF|AFLI|ch out of image plan", 
               interRes$Comment )

ytmp <- rep(0, dim(interRes)[1])
ytmp[idxBad] <- 1

mlog <- ulam(
  alist(y ~ dbinom(1, p),
        logit(p) <- a[included],
        a[included] ~ dnorm(0, sigma),
        sigma ~ dnorm(0,10)
  ),
  data = list(y = ytmp, included = interRes$included + 1), 
  chains = 1, 
  cores = 1, 
  warmup = 1000,
  iter = 15000
)

precis(mlog, depth = 2)
precis(mlog_min, depth = 2)
precis(mlog_max, depth = 2)

range(abs(lamin_dist)); range(abs(lamax_dist))

# -----------------------------------------------------------------
#
# Simulate
#

x_seq <- seq(from = 0, to = 0.6, length = 500)

# sim la min
post <- extract.samples(mlog_min)
l.min <- link(mlog_min , data = data.frame(x = x_seq, included = 2), n = 1e4)
mu.min <- apply(l.in,2, mean)
mu.min.ci <- apply(l.in,2, PI, prob = 0.95)


# sim la max
post <- extract.samples(mlog_max)
l.max <- link(mlog_max , data = data.frame(x = x_seq, included = 2), n = 1e4)
mu.max <- apply(l.in,2, mean)
mu.max.ci <- apply(l.in,2, PI, prob = 0.95)


# -----------------------------------------------------------------
#
# Start plot
#

png("logReg_outofplane_210426.png",
    width=6,height=7,res=300,units="in")

par(mfrow=c(3,1))

# -----------------------------------------------------------------
#
# Plot model la max
#

plot(NULL, xlim = c(0, 0.6), ylim = c(0,1),  bty="n",
     xaxt = "n", 
     ylab = "Prob. of out of plane", 
     xlab = "q. distance from median LAmax",
     cex.lab=1.2,
     cex.axis=1.2)

points(jitter(abs(lamax_dist)), y, col = alpha(rangi2, alpha = 0.2), pch = 19)
post <- extract.samples(mlog_max)
p.link <- function(x) {
  logodds <- with(post, a + b*x)
  return(logistic(logodds))
}

pred.raw <- sapply(x_seq, function(i) p.link(i))
pred.p <- apply(pred.raw, 2, mean)
pred.p.PI <- apply(pred.raw, 2, PI)

lines(x_seq, pred.p, lwd = 2)
shade(pred.p.PI, x_seq)


# -----------------------------------------------------------------
#
# Plot model la min
#

plot(NULL, xlim = c(0, 0.6), ylim = c(0,1),  bty="n",
     #xaxt = "n", 
     ylab = "Prob. of out of plane", 
     xlab = "q. distance from median LAmin",
     cex.lab=1.2,
     cex.axis=1.2)

points(jitter(abs(lamin_dist)), y, col = alpha(rangi2, alpha = 0.2), pch = 19)
post <- extract.samples(mlog_min)
p.link <- function(x) {
  logodds <- with(post, a + b*x)
  return(logistic(logodds))
}

pred.raw <- sapply(x_seq, function(i) p.link(i))
pred.p <- apply(pred.raw, 2, mean)
pred.p.PI <- apply(pred.raw, 2, PI)

lines(x_seq, pred.p, lwd = 2)
shade(pred.p.PI, x_seq)


# -----------------------------------------------------------------
#
# Plot model mlog
# thres : 1,10,20,30

post <- extract.samples(mlog)

hist(logistic(post$a[,2]), breaks = 50, 
     col = brewer.pal("Paired",n=4)[1],
     ylab = "Dens",
     xlab = "Probability of image out of plane",
     xlim = c(0,1),
     main = "",
     cex.lab=1.2,
     cex.axis=1.2,
     freq = F

)

hist(logistic(post$a[,1]), breaks = 50, 
     col = brewer.pal("Paired",n=10)[5],
     xlim = c(0,1),
     main = "",
     freq = F,
     add = T
)

dev.off()

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

