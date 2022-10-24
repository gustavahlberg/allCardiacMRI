#
#
# Create table
#
#
# ---------------------------------------------
#
# Set relative path an source environment
#

rm(list = ls())
set.seed(42)
DIR <- system(intern = TRUE, ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(data.table)

ventr_1.fn <- "/home/projects/cu_10039/projects/cardiacMRI/modules/analyseImages_191107/results/table_ventricular_volume_all.csv"
wall_1.fn <- "/home/projects/cu_10039/projects/cardiacMRI/modules/analyseImages_191107/results/table_wall_thickness_all.csv"
ventr_2.fn <- "/home/projects/cu_10039/projects/repCardiacMRI/modules/analyseImages_200220/results/table_ventricular_volume_all.csv"
wall_2.fn <- "/home/projects/cu_10039/projects/repCardiacMRI/modules/analyseImages_200220/results/table_wall_thickness_all.csv"


eur_sample.fn <- "/home/projects/cu_10039/projects/allCardiacMRI/data/sampleList.all.etn_200506.tsv"
covarTab.fn <- "/home/projects/cu_10039/projects/allCardiacMRI/data/ukbCMR.all.boltlmm_210316.sample"


# ---------------------------------------------
#
# load and merge tabels 
#


sample.id <- read.table(eur_sample.fn, header = F)
covarTab <- read.table(covarTab.fn, header = T)



vent_1 <- read.table(ventr_1.fn, header = T, sep = ",")
vent_2 <- read.table(ventr_2.fn, header = T, sep = ",")
vent <- rbind(vent_1, vent_2)


wall_1 <- read.table(wall_1.fn, header = T, sep = ",")
wall_2 <- read.table(wall_2.fn, header = T, sep = ",")
wall <- rbind(wall_1, wall_2)
wall <- wall[!duplicated(wall), ]
row.names(wall) <- as.character(wall$X)
wall <- wall[wall$X %in% sample.id$V1, ]


tab <- vent[vent$X %in% sample.id$V1, ]
tab <- tab[!duplicated(tab), ]
any(duplicated(tab))

row.names(tab) <- as.character(tab$X)

tab$WT_Global.mm. <- NA 

tab[as.character(wall$X), ]$WT_Global.mm. <- wall$WT_Global..mm.



# ---------------------------------------------
#
# print 
#



write.table(tab,
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t",
            file = "ventricular_measurments_211014.tsv")



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
