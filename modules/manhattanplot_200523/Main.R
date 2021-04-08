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

sumstats.list = list.files("../../data/gwas_results/gwas_rtrn/",
                          pattern = "tsv.gz",
                           full.names = T)


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
                      chr = character(),
                      bp = character(),
                      startBP = character(),
                      stopBP = character(),
                      totBP = character(),
                      ALLELE1 = character(),
                      ALLELE0 = character(),
                      A1FREQ = character(),
                      bstd = character(), 
                      sestd = character())


for(sumstatsLA in sumstats.list) {
  
  source("loadData.R")
  source("defineLocusRegion.R")
  #source("manhattanPlot.R")
  print(sumstatsLA)
}

locusAll$gene = apply(locusAll,1,function(lo) {nearest_gene(lo,genelist)$GENE})


# ---------------------------------------------
#
# Get split set data
#


source("getSplitSetData.R")
locusAll <- do.call(rbind,locusAllList)


# ---------------------------------------------
#
# Get split set data
#

write.table(locusAll[,c("Pheno", "sentinel_rsid", "chr","bp", "ALLELE1", "ALLELE0","A1FREQ", 
                       "sent_pval", "beta", "se",
                       "gene","startBP","stopBP","totBP",
                       "beta_set1", "se_set1", "pval_set1",
                       "beta_set2", "se_set2", "pval_set2"
                       )],
            file = "../../results/tables/definedLocus_201207.tab",
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


