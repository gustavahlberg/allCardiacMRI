

in1Fn = "~/Projects/cardiacMRI/modules/extrct_atrialVol_200106/results/table_atrial_volume_all.csv"
in2Fn = "~/Projects/repCardiacMRI/modules/extrct_atrialVol_200225/results/rep_table_atrial_volume_all.csv"

la_tab1 = read.csv(in1Fn,
                  stringsAsFactors = F,
                  header = T)

la_tab2 = read.csv(in2Fn,
                  stringsAsFactors = F,
                  header = T)


la_tab <- rbind(la_tab1, la_tab2)


la_tab <- la_tab[as.character(la_tab$X) %in% as.character(phenoTab$IID),]

la_tab <- la_tab[-which(duplicated(la_tab)),]

la_tab <- la_tab[!as.character(la_tab$X) %in% exclude,]
rownames(la_tab) <- as.character(la_tab$X)


df$HR <- NA
df[rownames(la_tab),]$HR <- la_tab$HR

hist(df$HR)
