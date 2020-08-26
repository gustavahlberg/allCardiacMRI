# ----------------------------------
#
# 6)  C + T bootstrap
#
# ---------------------------------
#
# load
#



pheno = 'latef'

library(parallel)
library(tidyverse)
library(bigsnpr)
load("data/sampleData.rda", verbose = T)
load(paste0("data/snpgwasdata_", pheno,".rda"), verbose = T)


matdata = paste0("data/",pheno,".rds")
phenoTabIncl = phenoTab[ind.indiv,]

ukbb <- snp_attach(matdata)
G <- ukbb$genotypes

CHR <- as.integer(ukbb$map$chromosome)
POS <- ukbb$map$physical.pos
rs <- ukbb$map$rsid


all(regGwas$snp == rs)
lpval <- -log10(regGwas$p)
y = phenoTabIncl[,pheno]

# shift beta's
beta = -1*regGwas$beta

grid.lps = seq(from= -log10(1e-2), to = -log10(5e-08), by = exp(log(0.2))) 


# ---------------------------------
#
# clump
#


print("running clumping")
all_keep <- snp_grid_clumping(
    G, CHR, POS, lpS = lpval, ind.row = ind.train,
    grid.thr.r2 = c(0.1, 0.2, 0.5, 0.8),
    grid.base.size = c(50, 200, 500, 1000),
    ncores = 6)
print("completed clumping")


# ---------------------------------
#
# make grid
#


grid2 <- attr(all_keep, "grid") %>%
    mutate(thr.lp = list(grid.lps), num = row_number()) %>%
    unnest()



grid2$snpsize = sapply(1:dim(grid2)[1], function(i) {
    max_prs <- grid2[i,]
    ind.keep <- unlist(map(all_keep, max_prs$num))
    sum(lpval[ind.keep] > as.numeric(max_prs[, 'thr.lp']))
})

grid2[grid2$thr.r2 == 0.5 & grid2$thr.lp == 2,]


grid.fn = sprintf("results/grid_%s.tab", pheno)
write.table(grid2,
            file = grid.fn,
            quote = F,
            col.names = T,
            row.names = F)
