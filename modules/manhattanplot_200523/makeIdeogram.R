# ---------------------------------------------
#
# Ideogram
#
# ---------------------------------------------
#
# load
#

data(human_karyotype, package="RIdeogram")
data(gene_density, package="RIdeogram")
data(Random_RNAs_500, package="RIdeogram")


ideogram(karyotype = human_karyotype)




# ---------------------------------------------
#
# label loci
#


head(Random_RNAs_500)
head(locusAll)

locusAll$Type = gsub("rntrn_","",locusAll$Pheno)
locusAll$color =  NA; locusAll$Shape =  NA
locusAll$Shape[grep("max|min",locusAll$Pheno)] <- "triangle"
locusAll$Shape[-grep("max|min",locusAll$Pheno)] <- "circle"
locusAll$Start = as.numeric(locusAll$bp)
locusAll$End = as.numeric(locusAll$bp)

cols = c("33a02c", "6a3d9a", "ff7f00", "ff007f","ddbdbd","7f00ff","b2df8a")

for (i in 1:length(unique(locusAll$Type))) {
  pheno = unique(locusAll$Type)[i]
  locusAll$color[locusAll$Type == pheno] = cols[i]
}


# ---------------------------------------------
#
# ideogram
#

# rm lamax & lamin + chr8 hit
locusAll.bakk = locusAll
dim(locusAll[-which(locusAll$Type == 'lamin' | locusAll$Type == 'lamax' | locusAll$sentinel_rsid == 'rs7842765'),])
locusAll = locusAll[-which(locusAll$Type == 'lamin' | locusAll$Type == 'lamax' | locusAll$sentinel_rsid == 'rs7842765'),]

locusAll$Chr = locusAll$chr
ideagramLabels = locusAll[,c("Type","Shape","Chr","Start","End","color")]
sort(as.numeric(unique(ideagramLabels$Chr)))


ideogram2(karyotype = human_karyotype[sort(as.numeric(unique(ideagramLabels$Chr))),], 
         label = ideagramLabels, 
         label_type = "marker",
         overlaid = gene_density,
         colorset1 = c("#f7f7f7", "#2c7fb8"),
         width = 250,
         Lx =  240
         )

#convertSVG("chromosome.svg", device = "png", width = 8, height = 6)

convertSVG("chromosome.svg", device = "tiff", width = 8, height = 6, dpi = 300)




data(human_karyotype, package="RIdeogram") #reload the karyotype data
ideogram(karyotype = human_karyotype, overlaid = gene_density, label = LTR_density, label_type = "heatmap", colorset1 = c("#f7f7f7", "#e34a33"), colorset2 = c("#f7f7f7", "#2c7fb8")) #use the arguments 'colorset1' and 'colorset2' to set the colors for gene and LTR heatmaps, separately.
convertSVG("chromosome.svg", device = "png")