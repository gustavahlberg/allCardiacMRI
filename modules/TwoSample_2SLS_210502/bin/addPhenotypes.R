#
#
# add phenotype
#
# ---------------------------------------------
#
# icd.R
#

source("bin/icd.R")

# ---------------------------------------------
#
# def HF
#

source("bin/defHF.R")

sum(rowSums(CMpheno[,-1]) >= 1)
sum(rowSums(HFpheno[,-1]) >= 1)

cm = ifelse(rowSums(CMpheno[,-1]) >= 1,1,0)
hf = ifelse(rowSums(HFpheno[,-1]) >= 1,1,0)
all(df$sample.id == CMpheno$sample.id);all(df$sample.id == HFpheno$sample.id)

df$cm = cm
df$hf = hf
df$hf_cm = ifelse(hf == 1 | cm == 1, 1,0)
sum(df$hf_cm )
sum(df$hf)


# ---------------------------------------------
#
# Type 2 Diabetes
#

source("bin/defT2D.R")
df$T2D <- ifelse(rowSums(T2Dpheno[,-1]) >= 1, 1, 0)

# ---------------------------------------------
#
# Hypertension
#


source("bin/defHT.R")
all(HTpheno$sample.id == df$sample.id)
df$HT = ifelse(rowSums(HTpheno[,-1]) >= 1,1,0)



# ---------------------------------------------
#
# def Stroke
#

source("bin/defStroke.R")



# ---------------------------------------------
#
# blood pressure
#


source("bin/defBloodPressure.R")




# ---------------------------------------------
#
# BMI
#

source("bin/bmi.R")



# ---------------------------------------------
#
# Heart rate
#


source("bin/heartRate.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################


