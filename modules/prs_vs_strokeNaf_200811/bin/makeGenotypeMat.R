# -------------------------
# 
# make big snpr matrix
#
# ------------------------
#
# load
#

phenos = c('ilamax', 'ilamin', 'laaef', 'lapef', 'latef')
#pheno = 'laaef'
library(tidyverse)
library(bigsnpr)
load("data/dfStroke.rda", verbose = T)

prsList <- list()

# ------------------------
#
# loop
#


for(pheno in phenos) {

    load(paste0("../prs_ct_bayes_200724/data/snpgwasdata_", pheno,".rda"), verbose = TRUE)
    load("../prs_ct_bayes_200724/data/sampleData.rda", verbose = TRUE)

    matdata = paste0("../prs_ct_bayes_200724/data/",pheno,".rds")
    phenoTabIncl = phenoTab[ind.indiv,]

    ukbb <- snp_attach(matdata)
    G <- ukbb$genotypes

    CHR <- as.integer(ukbb$map$chromosome)
    POS <- ukbb$map$physical.pos
    rs <- ukbb$map$rsid


    all(regGwas$snp == rs)
    lpval <- -log10(regGwas$p)
    phenoTabIncl = phenoTab[ind.indiv,]
    y = phenoTabIncl[,pheno]

    # shift beta's
    beta = -1*regGwas$beta


# ------------------------
#
# 
#

    bestCT = read.table("../prs_ct_bayes_200724/results/bestCT_models_200811.tsv",
                        stringsAsFactors = TRUE,
                        header = TRUE)

    print("running clumping")
    all_keep <- snp_grid_clumping(
        G, CHR, POS, lpS = lpval, ind.row = ind.train,
        grid.thr.r2 = bestCT[pheno, "thr.r2"],
        grid.base.size = bestCT[pheno, "size"]*bestCT[pheno, "thr.r2"],
        ncores = 6)
    print("completed clumping")

    ind.keep <- unlist(all_keep)
    sum(lpval[ind.keep] > as.numeric(bestCT[pheno, 'thr.lp']))

    snp_id <- unlist(list_snp_id)[ind.keep[lpval[ind.keep] > as.numeric(bestCT[pheno, 'thr.lp'])]]


    list_snp_id2 <- split(snp_id, gsub("(^\\d+).+","\\1",snp_id))
    list_snp_id2 <- list_snp_id2[as.character(c(1:22))]

 
# ------------------------
#
#  make genotype mat
#

    sample <- bigreadr::fread2("/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample")
    str(sample)
    (N <- readBin("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr10_v3.bgen",what = 1L, size = 4, n = 4)[4])
    sample <- sample[-1, ]
    nrow(sample) == N

    idx_strokeDF = which(sample$ID_1 %in% dfStroke$sample.id)
    backingfile = paste0("data/stroke_prs_",pheno)

    system.time(
        rds <- bigsnpr::snp_readBGEN(
                            bgenfiles = glue::glue("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
                            list_snp_id = list_snp_id2,
                            backingfile = backingfile,
                            ind_row = idx_strokeDF,
                            bgi_dir = "/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/",
                            ncores = 10
                        )
    ) 


# ------------------------
#
#  make prs
#


    ind <- ind.keep[lpval[ind.keep] > as.numeric(bestCT[pheno, 'thr.lp'])]
    strokeMat <- snp_attach(paste0(backingfile, ".rds"))
    T <- strokeMat$genotypes

    prs = big_prodVec(T, beta[ind])
    #print(cor(prs, y[ind.test]))

    prsList[[pheno]] <- prs         

}


save(prsList, file = "results/prsSinStroke_200812.rda")



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
