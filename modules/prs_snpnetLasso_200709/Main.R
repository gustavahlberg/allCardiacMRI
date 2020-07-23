#
# Module for making prs with
# snpnet lasso
# 
# 1) select unrelated samples sets training/test validation,
# 2) QC snpset
# 3) run fit_snpnet
# 4) predict on validation
# 5) save model
#
# ----------------------------------
#
# configs
#

library(data.table)
library(caret)

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


# ----------------------------------
#
# 1) select unrelated sample sets training/validation test
#


source("bin/makeSampleSets.R")


# ----------------------------------
#
# 2) QC snpset 
#


system("bash qcSnpset.sh")


# ----------------------------------
#
# 3) Format to pgen
#

system("bash makePgen.sh")
source("bin/makePgen.R")


# ----------------------------------
#
# 4) Train
#

set.seed(3456)
folds = createMultiFolds(tmp$lamin, k = 10, times = 3)


tmp = read.table("data/phenTrain.sort.phe",
                 stringsAsFactors = F,
                 header = T)
tmp$split = "val"
#idx = sample(seq(nrow(tmp)),floor(0.3*nrow(tmp)))
i = 1
idx = folds[[i]]
tmp$split[idx] <- "train"

#tmp$laaef_scale = scale(tmp$laaef)
#tmp$height_scale = scale(tmp$height)
#tmp$LVEF_scale = scale(tmp$LVEF)
#tmp$hi_aef <- ifelse(tmp$laaef_scale < -1, 1, 0 )



write.table(tmp,
            file = "data/phenTrain.sort.phe",
            row.names = F,
            col.names = T)
            

source("bin/train.R")



# ----------------------------------
#
# 4) Test
#



source("bin/test.R")

