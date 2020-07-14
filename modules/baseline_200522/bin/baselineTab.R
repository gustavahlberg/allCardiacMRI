#
#
# Baseline tab
#
# ---------------------------------------------
#
# make table 
#

allTabIncl = allTab[samples2includeAll,]


N = 35658
male = paste0(sum(allTabIncl$sex == 1), " (",100*signif(sum(allTabIncl$sex == 1)/N, digits = 2), ")")
age = paste0(median(allTabIncl$age), 
             " (",
             summary(allTabIncl$age)[2],"-" ,summary(allTabIncl$age)[5], ")")

height = paste0(signif(mean(allTabIncl$height),3), 
                " (", signif(sd(allTabIncl$height),1), ")")
weight = paste0(signif(mean(allTabIncl$weight),2), 
                " (", signif(sd(allTabIncl$weight),1), ")")
bmi = paste0(signif(mean(allTabIncl$bmi),2), 
             " (", signif(sd(allTabIncl$bmi),1), ")")

bsa = paste0(signif(mean(allTabIncl$bsa),3), 
             " (", signif(sd(allTabIncl$bsa),1), ")")

SBP = paste0(signif(mean(allTabIncl$sbp,na.rm=T),2),  
                " (", signif(sd(allTabIncl$sbp,na.rm=T),2), ")")

DBP = paste0(signif(mean(allTabIncl$dbp,na.rm=T),2),  
             " (", signif(sd(allTabIncl$dbp,na.rm=T),2), ")")

pr = paste0(signif(mean(allTabIncl$pulseRate,na.rm=T),2), 
            " (", signif(sd(allTabIncl$pulseRate,na.rm=T),2), ")")

  
stroke = paste0(sum(allTabIncl$stroke == 1), " (",100*signif(sum(allTabIncl$stroke == 1)/N, digits = 1), ")")
AF = paste0(sum(allTabIncl$af == 1), " (",100*signif(sum(allTabIncl$af == 1)/N, digits = 2), ")")
T2D = paste0(sum(allTabIncl$T2D == 1), " (",100*signif(sum(allTabIncl$T2D == 1)/N, digits = 3), ")")
CAD = paste0(sum(allTabIncl$CAD == 1), " (",100*signif(sum(allTabIncl$CAD == 1)/N, digits = 2), ")")
HT = paste0(sum(allTabIncl$HT == 1), " (",100*signif(sum(allTabIncl$HT == 1)/N, digits = 3), ")")
VHD = paste0(sum(allTabIncl$Valve == 1), " (",100*signif(sum(allTabIncl$Valve == 1)/N, digits = 1), ")")


baseLineTab = data.frame(varNames = c("N", "Age","Male", "Height", "Weight", "BMI", 
                                      "BSA", "SBP/DBP", "Pulse rate", "Stroke",
                                      "AF", "T2D", "CAD", "HT","VHD"),
                         varValues =  c(N,age,male,height,weight,bmi,
                                        bsa, paste(SBP,"/",DBP), pr, stroke,
                                        AF, T2D, CAD, HT, VHD))
           

# ---------------------------------------------
#
# cmr table
#

laparameters = c("lamax", "lamin", "ilamax", "ilamin", "laaef", "lapef", "latef")

laTab = allTabIncl[,laparameters]
cmrTab = data.frame(mean = colMeans(laTab),
                       sd = apply(laTab,2,sd)
                       )

cmrTab = data.frame(par = row.names(cmrTab),
                    ml=paste0(signif(cmrTab$mean,2)," (", signif(cmrTab$sd,2),")")
)


# ---------------------------------------------
#
# Print tables
#

write.xlsx(x = baseLineTab,
           file = "baselineCharacteristics.xlsx",
           sheetName = "baselineCharacteristics",
           col.names = T,
           row.names = F)


write.xlsx(x = cmrTab,
           file = "cmrCharacteristics.xlsx",
           sheetName = "cmrCharacteristics",
           col.names = T,
           row.names = F)




