#
#
# Plot PC's for ethnic homogenous population
#
# --------------------------------------------

sample.eth.id <- read.table("../../data/sampleList.all.etn_200506.tsv",
                            header = F)$V1


repSL.fn = "../../../repCardiacMRI/data/cardiacMRI_samples.etn_200506.tsv"
priSL.fn= "../../../cardiacMRI/data/cardiacMRI_samples.etn_200219.tsv"
pri_eur.fn = "../../../cardiacMRI/data/ukb_eur_samples.tsv"
rep_eur.fn = "../../../repCardiacMRI/data/ukb_eur_samples.tsv"

rep_eur = read.table(rep_eur.fn, header = T, stringsAsFactors = F)
pri_eur = read.table(pri_eur.fn, header = T, stringsAsFactors = F)


repSl = read.table(repSL.fn, header = T, stringsAsFactors = F)
priSl = read.table(priSL.fn, header = T, stringsAsFactors = F)


mri_b1 = read.csv("../../../cardiacMRI/modules/analyseImages_191107/results/table_atrial_volume_all.csv",
                           header = T, stringsAsFactors = F)
                      
mri_b2 = read.csv("../../../repCardiacMRI/modules/analyseImages_200220/results/table_atrial_volume_all.csv",
                  header = T, stringsAsFactors = F)

length(unique(c(mri_b2$X, mri_b1$X)))

table(priSl$sample.id %in% mri_b1$X)

length(unique(c(mri_b2, mri_b1)))
table(unique(c(mri_b1)) %in% pri_eur$sample.id)


any(pri_eur$sample.id %in% rep_eur$sample.id)

all_eur <- rbind(pri_eur, rep_eur)

table(unique(c(mri_b1$X, mri_b2$X)) %in% all_eur$sample.id)

#----------------------------------------
#
# Plot 
#

df <- all_eur

# colors
set <- rep(1,nrow(df))
set[df$white] <- 4
#set[df$in.white.British.ancestry.subset==1] <- 2
set[df$eur_select] <- 3
#set[df$genCac == 1] <- 5

#set[df$genCac == 1] <- 5

cols <- c("gray80",
          brewer.pal("Dark2",n=4)[1], 
          brewer.pal("Dark2",n=4)[2], 
          brewer.pal("Dark2",n=4)[3],
          brewer.pal("Dark2",n=4)[4])

samp=sample(nrow(df),replace=F)

png("ukb_PC1&2_eur_selection_pca.png",width=16,height=16,res=300,units="in")
par(mar=c(4,5,0,0))
par(oma=c(0,0,0,0))
plot(df[samp,c("PC1","PC2")], col=cols[set[samp]], 
     cex=1.0, pch = 19, cex.axis = 1.5, cex.lab = 2)
dev.off()

png("ukb_PC1&2_zoom_eur_selection_pca.png",width=16,height=16,res=300,units="in")
par(mar=c(4,5,0,0))
par(oma=c(0,0,0,0))
plot(df[samp,c("PC1","PC2")],col=cols[set[samp]],cex=1.0, cex.axis = 1.5, cex.lab = 2, 
     xlim = c(-20,70), ylim = c(-70,20),
     pch = 19)
dev.off()

#samp <- 1:nrow(df)
png("ukb39588_eur_selection_pca.png",width=16,height=16,res=300,units="in")
pairs(df[samp,c("PC1","PC2","PC3","PC4")],col=cols[set[samp]],cex=.9, 
      cex.lab = 2,
      pch = 16)
dev.off()
