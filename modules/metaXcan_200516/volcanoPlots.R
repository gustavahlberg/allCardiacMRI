# ---------------------------------------------------------
#
# make volcano plot from MetaXcan results
# La volumes
#




tiff(filename = "MetaXcan_LaVolume_200909.tiff",
     width = 6.1, height = 6.1,
     units = 'in',
     res = 300)



files = list.files("results", full.names = T)

files = c("results/ilamax_la.txt", "results/ilamax_lv.txt",
          "results/ilamin_la.txt", "results/ilamin_lv.txt")

mypar(a = 2, b = 2, mar = c(5,4,1,2))

titles = data.frame(files = files, main = c("LAmax LA", "LAmax LV", "LAmin LA", "LAmin LV"))

for(file in files) {
  title = titles$main[titles$files == file]
  source("makeVolcanoPlot.R")
}

dev.off()



# ---------------------------------------------------------
#
# make volcano plot from MetaXcan results
# La volumes
#

tiff(filename = "MetaXcan_LaFunction_200923.tiff",
     width = 6.1, height = 8.5,
     units = 'in',
     res = 300)


files = list.files("results", full.names = T)

files = c("results/laaef_la.txt", "results/laaef_lv.txt",
          "results/lapef_la.txt", "results/lapef_lv.txt",
          "results/latef_la.txt", "results/latef_lv.txt")
titles = data.frame(files = files, main = c("LAAEF LA", "LAAEF LV", "LAPEF LA", "LAPEF LV",
                                            "LATEF LA", "LATEF LV"))

mypar(a = 3, b = 2, mar = c(5,4,1,2))

for(file in files) {
  title = titles$main[titles$files == file]
  source("makeVolcanoPlot.R")
}




dev.off()




#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
