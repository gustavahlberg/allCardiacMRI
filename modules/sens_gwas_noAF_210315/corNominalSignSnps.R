# ----------------------------------------------------
#
# check cor of loci in sens. gwas w/o AF pr valve disease
#
# ----------------------------------------------------
#
# load data
#

library(gsmr)

phenotab <- read.table("../../data/ukbCMR.all.boltlmm_210316.sample",
                      header = T)


sampleSize <- data.frame(noAf = 34945,
                         noValve = 35556,
                         sbp = 35567,
                         regular = 35658)

sensloci.fn <- c(list.files(pattern = "locusSnps.txt",
                            path = "results",
                            full.names = T),
                 list.files(pattern = "locusSnps.txt",
                            path = "../sens_gwas_sbp_210315/results",
                            full.names = T)
                 )



reploci.fn <- list.files(pattern = "^Locus_nominalSignSnps",
                         path = "../clumping_200518/results/",
                         full.names = T)

repList <- list()
sensList <- list()


for (i in 1:length(sensloci.fn)) {

    pheno <- gsub("rntrn_(.+)_locusSnps.txt", "\\1", basename(sensloci.fn[i]))

    sensList[[pheno]] <- read.table(sensloci.fn[i],
                                    header = T)

    if (gsub(".+_", "", pheno) == "noValve") {
        sensList[[pheno]]$n <- sampleSize$noValve
    }

    if (gsub(".+_", "", pheno) == "noAF") {
        sensList[[pheno]]$n <- sampleSize$noAf
    }
    if (gsub(".+_", "", pheno) == "sbp") {
        sensList[[pheno]]$n <- sampleSize$sbp
    }
    
    pheno <- gsub("_.+", "", pheno)


    repList[[pheno]] <- read.table(reploci.fn[grep(pheno, reploci.fn)],
                                   header = T)
    repList[[pheno]]$n <- sampleSize$regular
    rownames(repList[[pheno]]) <- repList[[pheno]]$SNP

}


# load loci
defloci <- read.table("../../results/tables/definedLocus_201204.txt",
                     header = T)



defloci$PvalNoAF <- NA
defloci$PvalNoValve <- NA
defloci$PvalAdjSBP <- NA

defloci$BetaNoAF <- NA
defloci$BetaNoValve <- NA
defloci$BetaAdjSBP <- NA

defloci$SeNoAF <- NA
defloci$SeNoValve <- NA
defloci$SeAdjSBP <- NA


defloci$corBetasNoAF <- NA
defloci$corBetasNoValve <- NA
defloci$corBetasAdjSBP <- NA


defloci$corChiNoAF <- NA
defloci$corChiNoValve <- NA
defloci$corChiAdjSBP <- NA



# ----------------------------------------------------
#
# Standardization of betas 
#


for (pheno in names(sensList)) {
    print(pheno)
    x  <- sensList[[pheno]]
    
    res_std <- std_effect(snp_freq = x[, "A1FREQ"],
                         b = x[, "BETA"],
                         se = x[, "SE"],
                         n = x[, "n"])

    sensList[[pheno]]$bstd <- res_std$b
    sensList[[pheno]]$sestd <- res_std$se


}


for (pheno in names(repList)) {
    print(pheno)
    x  <- repList[[pheno]]
    
    res_std <- std_effect(snp_freq = x[, "A1FREQ"],
                         b = x[, "BETA"],
                         se = x[, "SE"],
                         n = x[, "n"])

    repList[[pheno]]$bstd <- res_std$b
    repList[[pheno]]$sestd <- res_std$se

}




# ----------------------------------------------------
#
# Subset and sort to snps in reported loci
#


for (i in 1:length(repList)) {

    pheno <- names(repList)[i]
    pheno2 <- paste0(pheno, "_noAF")
    pheno3 <- paste0(pheno, "_noValve")
    pheno4 <- paste0(pheno, "_sbp")

    repPheno <- repList[[pheno]]
    lociPheno <- defloci[defloci$Pheno == paste0("rntrn_", pheno), ]
    lociPheno <- split(lociPheno, lociPheno$sentinel_rsid)

    x <- sensList[[pheno2]]
    x <- x[x$SNP %in% repList[[pheno]]$SNP, ]
    all(x$SNP %in% repList[[pheno]]$SNP)
    rownames(x) <- x$SNP
    x <- x[repList[[pheno]]$SNP, ]
    all(x$SNP == repList[[pheno]]$SNP)
    x <- split(x, x$CHR)


    y <- sensList[[pheno3]]
    y <- y[y$SNP %in% repList[[pheno]]$SNP, ]
    all(y$SNP %in% repList[[pheno]]$SNP)
    rownames(y) <- y$SNP
    y <- y[repList[[pheno]]$SNP, ]
    all(y$SNP == repList[[pheno]]$SNP)
    y <- split(y, y$CHR)

    z <- sensList[[pheno4]]
    z <- z[z$SNP %in% repList[[pheno]]$SNP, ]
    all(z$SNP %in% repList[[pheno]]$SNP)
    rownames(z) <- z$SNP
    z <- z[repList[[pheno]]$SNP, ]
    all(z$SNP == repList[[pheno]]$SNP)
    z <- split(z, z$CHR)

    
    for (j in 1:length(lociPheno)) {
        
        locus <- lociPheno[[j]]
        chr <- as.character(locus$chr)

        x_chr <- x[[chr]]
        x_locus <- x_chr[x_chr$BP >= locus$startBP & x_chr$BP <= locus$stopBP, ]

        y_chr <- y[[chr]]
        y_locus <- y_chr[y_chr$BP >= locus$startBP & y_chr$BP <= locus$stopBP, ]

        z_chr <- z[[chr]]
        z_locus <- z_chr[z_chr$BP >= locus$startBP & z_chr$BP <= locus$stopBP, ]


        repLocus <- repPheno[rownames(x_locus), ]

                                        # no AF
        locus$PvalNoAF <- x_locus[locus$sentinel_rsid, ]$P_BOLT_LMM
        locus$corChiNoAF <- cor(x_locus$CHISQ_BOLT_LMM, repLocus$CHISQ_BOLT_LMM )
        locus$corBetasNoAF <- cor(x_locus$bstd, repLocus$bstd)
                                        # no valve
        locus$PvalNoValve <- y_locus[locus$sentinel_rsid, ]$P_BOLT_LMM
        locus$corChiNoValve <- cor(y_locus$CHISQ_BOLT_LMM, repLocus$CHISQ_BOLT_LMM)
        locus$corBetasNoValve <- cor(y_locus$bstd, repLocus$bstd)
                                        # SBP adj
        locus$PvalAdjSBP <- z_locus[locus$sentinel_rsid, ]$P_BOLT_LMM
        locus$corChiAdjSBP <- cor(z_locus$CHISQ_BOLT_LMM, repLocus$CHISQ_BOLT_LMM)
        locus$corBetasAdjSBP <- cor(z_locus$bstd, repLocus$bstd)

        locus$BetaNoAF <- x_locus[locus$sentinel_rsid, ]$bstd
        locus$BetaNoValve <- y_locus[locus$sentinel_rsid, ]$bstd
        locus$BetaAdjSBP <- z_locus[locus$sentinel_rsid, ]$bstd
        
        locus$SeNoAF <- x_locus[locus$sentinel_rsid, ]$sestd
        locus$SeNoValve <- y_locus[locus$sentinel_rsid, ]$sestd
        locus$SeAdjSBP <- y_locus[locus$sentinel_rsid, ]$sestd



        defloci[defloci$Pheno == paste0("rntrn_", pheno) &
                defloci$sentinel_rsid == locus$sentinel_rsid, ] <- locus
    }
}




# -----------------------------------------
#
# convert betas from standard deviation
#


phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")
#pheno <- "ilamax"

# no af
idxSamples <- which(!is.na(phenotab$rntrn_ilamin) &
                   phenotab$af == 0)

for(pheno in phenos) {
    print(pheno)
    sdpheno <- sd(phenotab[idxSamples, pheno])

    defloci[defloci$Pheno == paste0("rntrn_", pheno),]$BetaNoAF <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno),]$BetaNoAF), digits = 3)

    defloci[defloci$Pheno == paste0("rntrn_", pheno),]$SeNoAF <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno),]$SeNoAF), digits = 3)
}


# no valve
idxSamples <- which(!is.na(phenotab$rntrn_ilamin) &
                    phenotab$Valve == 0)

for(pheno in phenos) {
    print(pheno)
    sdpheno <- sd(phenotab[idxSamples, pheno])

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaNoValve <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaNoValve), digits = 3)

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeNoValve <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeNoValve), digits = 3)
}


# no valve
idxSamples <- which(!is.na(phenotab$rntrn_ilamin) &
                    phenotab$Valve == 0)

for(pheno in phenos) {
    print(pheno)
    sdpheno <- sd(phenotab[idxSamples, pheno])

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaNoValve <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaNoValve), digits = 3)

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeNoValve <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeNoValve), digits = 3)
}



# sbp adj.
idxSamples <- which(!is.na(phenotab$rntrn_bp10Hgilamin))


for(pheno in phenos) {
    print(pheno)
    sdpheno <- sd(phenotab[idxSamples, pheno])

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaAdjSBP <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$BetaAdjSBP), digits = 3)

    defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeAdjSBP <- signif(sdpheno*as.numeric(defloci[defloci$Pheno == paste0("rntrn_", pheno), ]$SeAdjSBP), digits = 3)

}





# ----------------------------------------------------
#
# Order and round
#


defloci <- defloci[order(defloci$Pheno, defloci$chr, defloci$bp), ]


defloci[, grep("cor", colnames(defloci))] <- signif(defloci[, grep("cor", colnames(defloci))], digits = 3)



# ----------------------------------------------------
#
# Save results
#


d <- format(Sys.time(), "%y%m%y")

write.table(x = defloci,
            file = paste0("definedLocus_w_sensAnalyses_", d, ".tsv"),
            col.names = T,
            row.names = T,
            quote = T
            )




