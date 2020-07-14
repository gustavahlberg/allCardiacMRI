#
#
# Module for manhattan plots and
# ideagram
#
# ---------------------------------------------
#
# Configs, set relative path and source enviroment
#


rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")



source("load.R")
source("getAllgenes.R")
# genelist = read.table("glist-hg19",
#                       stringsAsFactors = F,
#                       header = F
#                       )
# colnames(genelist) <- c("CHR","START","END", "GENE")

sumstats.list = list.files("../../data/gwas_results/gwas_rtrn/",full.names = T)


# ---------------------------------------------
#
# define locus region
#






# ---------------------------------------------
#
# manhattan plot 
#

locusAll = data.frame(Pheno = character(),
                      sentinel_rsid = character(),
                      sent_pval = character(),
                      chr =character(),
                      bp = character(),
                      startBP = character(),
                      stopBP = character(),
                      totBP = character())


for(sumstatsLA in sumstats.list) {
  
  source("loadData.R")
  source("defineLocusRegion.R")
  #source("manhattanPlot.R")
  print(sumstatsLA)
}


write.table(locusAll[c("Pheno", "sentinel_rsid","sent_pval", "chr","bp","gene","startBP","stopBP","totBP")],
            file = "../../results/tables/definedLocus_200524.tab",
            quote = F,
            row.names = F,
            col.names = T)

# ---------------------------------------------
#
# Ideogram
#


source("makeIdeogram.R")




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################


