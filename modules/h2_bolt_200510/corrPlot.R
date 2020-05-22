library(corrplot)
source("http://www.sthda.com/upload/rquery_cormat.r")



#h2 = signif(gencormatNum, digits = 3)
phmat = signif(phenocorrMat, digits = 3)

tiff(filename = "results/PhenotypeCorrelationPlot.tiff",
     width = 10.1, height = 10.1,
     units = 'in',
     res = 300)


corrplot.mixed(phmat, tl.pos = 'lt', diag = 'n',
               lower.col = "black", order ="hclust",
               number.digits = 3)

# corrplot.mixed(h2, tl.pos = 'lt', diag = 'l',
#                lower.col = "black", order ="hclust",
#                number.digits = 3)


dev.off()
