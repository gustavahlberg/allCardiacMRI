# ---------------------------------------------------------
#
# make volcano plot from MetaXcan results
# La volumes
#




tiff(filename = "MetaXcan_LaVolume_200517.tiff",
     width = 6.1, height = 8.5,
     units = 'in',
     res = 300)



files = list.files("results", full.names = T)

files = c("results/lamax_la.txt", "results/lamax_lv.txt",
          "results/lamin_la.txt", "results/lamin_lv.txt")

mypar(a = 3, b = 2, mar = c(5,4,1,2))

for(file in files) 
  source("makeVolcanoPlot.R")


dev.off()



# ---------------------------------------------------------
#
# make volcano plot from MetaXcan results
# La volumes
#

tiff(filename = "MetaXcan_LaFunction_200517.tiff",
     width = 6.1, height = 8.5,
     units = 'in',
     res = 300)


files = list.files("results", full.names = T)

files = c("results/laaef_la.txt", "results/laaef_lv.txt",
          "results/lapef_la.txt", "results/lapef_lv.txt",
          "results/latef_la.txt", "results/latef_lv.txt")

mypar(a = 3, b = 2, mar = c(5,4,1,2))

for(file in files) 
  source("makeVolcanoPlot.R")




dev.off()




#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
