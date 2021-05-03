# ---------------------------------------------
#
# 3. ICC & Bland Altman plot
#
# ---------------------------------------------
#
# range lamin & lamax
#

allTab.fn = "../../data/ukbCMR.all.boltlmm_200506.sample"

samples2excludeAll = as.character(read.table("../../data/sample2exclude.all.snpTest_200506.list")$V1)


allTab = read.table(allTab.fn,
                    stringsAsFactors = F,
                    header = T)

lamax_range <- range(allTab[!is.na(allTab$rntrn_ilamax),]$lamax)
lamin_range <- range(allTab[!is.na(allTab$rntrn_ilamin),]$lamin)


# ---------------------------------------------
#
# load
#

interRes <- read.table(file = "InterResults.tsv", 
                       header = T,
                       sep = "\t")


# ---------------------------------------------
#
# ICC intraclass correlation coefficient r
#

dfTmp <- interRes[interRes$included == 1,]

# max

icc(cbind(dfTmp$Biplane_LAmin, dfTmp$LAV.min..mL.),
    model = "o")

# min
icc(cbind(dfTmp$Biplane_LAmax, dfTmp$LAV.max..mL.),
    model = "o")


# ---------------------------------------------
#
# LAmax
#

source("bin/baLamax.R")


# ---------------------------------------------
#
# LAmin
#


source("bin/baLamin.R")


# ---------------------------------------------
#
# Logistic regression
#


source("bin/outlierLogistic.R")



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
# idxFiltered <- which(interRes$LAV.min..mL. < lamin_range[1] |
#                       interRes$LAV.min..mL. > lamin_range[2])
# idxFiltered <- which(interRes$LAV.max..mL. < lamax_range[1] |
#                        interRes$LAV.max..mL. > lamax_range[2])
# df <- interRes[c(which(interRes$included == 1), idxFiltered),]

df <- interRes[which(interRes$included == 1), ]
df <- interRes

#df <- df[!is.na(df$Biplane_LAmin),]

df <- df[!is.na(df$Biplane_LAmax),]
A <- df$LAV.max..mL.
B <- as.numeric(df$Biplane_LAmax)

idxBad <- grep("AFLI|out of image plan", 
               df$Comment )
#df <- df[-3,]

plot(A,B, bg = col)

cor(A,B)
icc(cbind(A,B))
mean(A-B,na.rm = T); max(abs(A-B),na.rm = T)

col <- rep(brewer.pal("Paired",n=4)[1], dim(df)[1])
col[df$included == 0 ] <- brewer.pal("Paired",n=10)[5]
#col[idxBad ] <- "red"

shape <- rep(21, dim(df)[1])
#shape[df$included == 0] <- 22

df$shape <- shape
df$col <- col
max(A - B)
mean(A - B)
plot(A,B, col = "black", bg = col, pch = 21)
model1 <- lm(B ~ A)

StdDev<- sd(model1$residuals)
UpperLine<- model1$coefficients[1]+model1$coefficients[2]*A + StdDev
LowerLine<- model1$coefficients[1]+model1$coefficients[2]*A - StdDev
abline(model1)

polygon(A, UpperLine)
lines(A, B, type = "l", lty = 1)

shade
shade(cbind(A,B), c(0,50))



models <- seq( from=0 , to=1 , length.out=100 )
prior <- rep( 1 , 100 )
likelihood <- dbinom( 6 , size=9 , prob=models )
posterior <- likelihood * prior
posterior <- posterior / sum(posterior)
plot( posterior ~ models , type="l" )
shade( posterior ~ models , c(0,0.5) )


bland.altman.plot(A, B, 
                  main="This is a Bland Altman Plot", 
                  xlab="Means", ylab="Differences",
                  pch = shape,
                  bg = col,
                  col = 'black',
                  xlim = c(0,5+max((A+B)/2, na.rm = T)),
                  #ylim = c(5-min(A-B),5+max(A-B)),
                  )


bland.altman.plot(A, B, 
                  main="This is a Bland Altman Plot", 
                  xlab="Means", ylab="Differences",
                  pch = shape,
                  bg = col,
                  col = 'black',
                  xlim = c(5-min(A+B/2,na.rm = T), 100),
                  #ylim = c(5-min(A-B),5+max(A-B)),
)




df <- interRes[interRes$included == 1,]

df <- df[!is.na(df$Biplane_LAmax),]

bland.altman.plot(df$Biplane_LAmax, df$LAV.max..mL., 
                  main="This is a Bland Altman Plot", 
                  xlab="Means", ylab="Differences")
