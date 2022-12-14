# --------------------------------
# 
# 3) C+T
#
# ----------------------------------
#
# load
#

library(parallel)
load("../prs_ct_bayes_200724/data/sampleData.rda", verbose = T)
load("data/list_snp_id.rda", verbose = TRUE)
load("data/samplesOrdered.rda", verbose = TRUE)
load("data/dfAF.rda", verbose = TRUE)


matdata = "data/afCohort.rds"
phenoTabIncl = phenoTab[ind.indiv,]

ukbb <- snp_attach(matdata)
G <- ukbb$genotypes

CHR <- as.integer(ukbb$map$chromosome)
POS <- ukbb$map$physical.pos
map <- ukbb$map
map$marker.ID <- paste(paste(gsub("^0","",map$chromosome), map$physical.pos, sep = ":"), map$allele1, map$allele2, sep = "_")


info_snp$markerID <- paste(paste(info_snp$chr, info_snp$pos, sep = ":"), info_snp$a0, info_snp$a1, sep = "_")

all(info_snp$markerID == map$marker.ID)

lpval <- -log10(info_snp$p)
beta = -info_snp$beta
y = df$AF


# ---------------------------------
#
# index
#

ind.test = which(df$sample.id %in% phenoTab$FID)
ind.train = which(!df$sample.id %in% phenoTab$FID)


# ---------------------------------
#
# multi prs
#

set.seed(12345)
bsResList <- list()
S = 1000

load("data/all_keep.rda", verbose = TRUE)
#system("multiPrs.pbs")

grid.lps = seq(from= -log10(5e-3), to = -log10(5e-08), by = exp(log(0.4)) )
grid.lps = c(grid.lps, -log10(5e-08))
grid2 <- attr(all_keep, "grid") %>%
    mutate(thr.lp = list(grid.lps), num = row_number()) %>%
    unnest()
s <- nrow(grid2)


bsResList <- mclapply(seq(S), function(j) {
    print(paste("iter:", j))
    ind.boot = sample(ind.train, size = length(ind.train), replace = T)
                                        #pred.base = predict(mod.base, phenoTabIncl[ind.boot,])
    
    res = lapply(1:dim(grid2)[1], function(i) {
        max_prs <- grid2[i,]
        ind.keep <- unlist(map(all_keep, max_prs$num))
        singlePrs <- snp_PRS(G, beta[ind.keep],
                             ind.test = ind.boot,
                             ind.keep = ind.keep,
                             lpS.keep = lpval[ind.keep],
                             thr.list = max_prs$thr.lp)

        bigstatsr::AUC(singlePrs, y[ind.boot])
    })


    gridRes = cbind(grid2, auc = (do.call(rbind, res)))
    gridRes$iter = j
    return(gridRes)

}, mc.cores = 20)

bootstrapResults.fn = "results/bootstraped_CTPrs_AF.rds"
save(bsResList, file = bootstrapResults.fn)

###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
