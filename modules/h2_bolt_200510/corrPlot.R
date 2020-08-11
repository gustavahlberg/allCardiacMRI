library(corrplot)
source("http://www.sthda.com/upload/rquery_cormat.r")



h2 = signif(gencormatNum, digits = 3)
h2.bakk = h2
#phmat = signif(phenocorrMat, digits = 3)
subsetPhenos = c("ilamax","ilamin", "laaef", "lapef", "latef","LVEF","LVEDV", "LVESV")

h2 = h2[subsetPhenos,subsetPhenos]
newNames = c("LAmax","LAmin", "LAAEF", "LAPEF", "LATEF","LVEF","LVEDV", "LVESV")
colnames(h2) <- newNames
rownames(h2) <- newNames

tiff(filename = "results/GeneticCorrelationPlot.tiff",
     width = 10.1, height = 10.1,
     units = 'in',
     res = 300)


# corrplot.mixed(phmat, tl.pos = 'lt', diag = 'n',
#                lower.col = "black", order ="hclust",
#                number.digits = 3)

corrplot.mixed(h2, tl.pos = 'lt', diag = 'l',
               lower.col = "black", order ="hclust",
               number.digits = 3)


dev.off()
