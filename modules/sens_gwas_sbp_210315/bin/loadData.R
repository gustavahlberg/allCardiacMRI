#
# Load data
#
# ---------------------------------------------

allTab.fn = "../../data/ukbCMR.all.boltlmm_200506.sample"
out.fn <- "../../data/ukbCMR.all.boltlmm_210316.sample"

samples2excludeAll = as.character(
  read.table("../../data/sample2exclude.all.snpTest_200506.list")$V1)


allTab = read.table(allTab.fn,
                    stringsAsFactors = F,
                    header = T)

rownames(allTab) = as.character(allTab$FID)


samples2includeAll = rownames(allTab)[!rownames(allTab) %in% samples2excludeAll]


allTab[samples2includeAll,]


