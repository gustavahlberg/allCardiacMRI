# -------------------------
# 
# 5) variable selection 4 stroke
#
# ----------------------------------------
#
# load
#


library(lubridate)
load("data/dfStroke.rda", verbose = TRUE)
load("results/prsSinStroke_200812.rda", verbose = TRUE)

sample <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
sample <- sample[-1, ]

sampleOrdered = sample$ID_1[which(sample$ID_1 %in% dfStroke$sample.id)]

# check if ordered
all(dfStroke$sample.id == sampleOrdered)



# ----------------------------------------
#
# make df
#

prs = scale(do.call(cbind, prsList))
ageCovar = dfStroke$ageAtIschStroke
ageCovar[is.na(ageCovar)] <- dfStroke$age[is.na(ageCovar)]

df = data.frame(sample.id = dfStroke$sample.id,
                stroke = ifelse(dfStroke$stroke == -9999, 0,1),
                ischStroke = ifelse(dfStroke$IschStroke == -9999, 0,1),
                sex = dfStroke$sex,
                age = ageCovar,
                prs)

x = as.matrix(data.frame(sex = dfStroke$sex,
                         age = ageCovar,
                         prs,
                         ilamax_laaef = prs[,'ilamax']*prs[,'laaef'],
                         ilamax_lapef = prs[,'ilamax']*prs[,'lapef'],
                         ilamax_latef = prs[,'ilamax']*prs[,'latef'],
                         ilamin_laaef = prs[,'ilamin']*prs[,'laaef'],
                         ilamin_lapef = prs[,'ilamin']*prs[,'lapef'],
                         ilamin_latef = prs[,'ilamin']*prs[,'latef']
                         ))

y = df$ischStroke

cvfit = cv.glmnet(x, y,
                  family = "binomial",
                  type.measure = "auc",
                  alpha=1)


summary(glm(y ~ x, family = binomial()))
thres1 = quantile(x[,'latef'], 0.1)
thres2 = quantile(x[,'ilamin'], 0.9)
hiprs = ifelse(x[,'laaef'] < thres1 & x[,'ilamin'] > thres2, 1,0)

summary(glm(y ~ hiprs + x[,'sex'] + x[,'age'], family = binomial()))


summary(lm(na.omit(ageCovar) ~ hiprs[!is.na(ageCovar)]))
