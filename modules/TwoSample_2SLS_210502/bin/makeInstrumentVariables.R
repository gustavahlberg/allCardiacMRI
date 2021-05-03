# ---------------------------------------------
#
# make instrument variables
#
# ---------------------------------------------
#
# Load data
#



gwas_loci <- list()

phenos <- c("ilamin", "ilamax", "laaef", "lapef", "latef")


### loop
for (pheno in phenos) {

  lead.fn <- paste0("../clumping_200518/results/gwSign_rntrn_",
                   pheno,
                   "_ALL.clumped")

    gwas.fn <- paste0("../gwas_w_bolt_v2_200420/results/gwas_rtrn/rntrn_",
                      pheno, 
                    ".bgen.stats.betastd.tsv.gz")

  gwas <- fread(gwas.fn, stringsAsFactors = F, header = T)
  gwas <- data.frame(gwas, stringsAsFactors = F)


  loci.fn <- paste0("../clumping_200518/results/gwSign_rntrn_",
                   pheno,
                  "_ALL.clumped")
  loci = read.table(loci.fn,
                    header = T,
                    stringsAsFactors = F)


  gwSign <- gwas[gwas$SNP %in% loci$SNP, ]

  gwas_loci[[pheno]] <-gwSign

}

#rm 
gwas_loci$ilamax <- gwas_loci$ilamax[!gwas_loci$ilamax$SNP %in% "rs7842765", ]



# ---------------------------------------------
#
# PRS
#

phenos <- c("ilamax", "ilamin", "laaef", "lapef", "latef")

prs <- matrix(data = NA, nrow = nrow(varTab) -2, ncol = 7,
              dimnames = list(rownames(varTab[-(1:2), ]),
                                       c(phenos, "vol", "func"))
              )


colnames(varTab) <- gsub( "\\..+$", "",colnames(varTab))


for (pheno in phenos) { 

    print(pheno)
    X <- matrix(as.numeric(unlist(varTab[-c(1:2), gwas_loci[[pheno]]$SNP])),
                nrow = nrow(varTab[-c(1:2), ])
                )
    
    rownames(X) <- rownames(varTab[-c(1:2), ])
    
    prs[, pheno] <- X %*% -gwas_loci[[pheno]]$bstd
}


for (comp in c("vol", "func")) {

    if (comp == "vol") {
        pheno <- c("ilamax", "ilamin") 
    }
    if (comp == "func") {
        pheno <- c("latef", "laaef") 
    }


    print(pheno)
    X <- matrix(as.numeric(unlist(varTab[-c(1:2),
                                         c(gwas_loci[[pheno[1]]]$SNP,
                                           gwas_loci[[pheno[2]]]$SNP)])),
                nrow = nrow(varTab[-c(1:2), ])
                )
    
    rownames(X) <- rownames(varTab[-c(1:2), ])
    
    prs[, comp] <- X %*% -c(gwas_loci[[pheno[1]]]$bstd, gwas_loci[[pheno[2]]]$bstd)

}



#prs <- scale(prs)





###################################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###################################################################



set <- data.frame(latef = NA,
                  prs_latef = prs[, "latef"],
                  row.names = rownames(prs))

set[as.character(phenoTab$FID),]$latef <- scale(phenoTab$latef)



fit <- lm(latef ~ prs_latef , data = set[as.character(phenoTab$FID), ])

hat_laaef <- predict(fit, newdata = set)
names(hat_laaef) <- rownames(set)


summary(glm(df[testSet,]$AF ~ prs[testSet, phenos[5]],
            family = binomial()))

summary(glm(df[testSet,]$AF ~ hat_laaef[testSet],
            family = binomial()))



summary(glm(phenoTab$af ~ prs[as.],
            family = binomial()))



testSet <- rownames(df[!df$sample.id %in% phenoTab$IID, ])

summary(glm(AF ~ prs[testSet, phenos[5]] + sex + age + PC1 + PC2 + PC3 + PC4,
            family = binomial(),
            data = df[testSet, ]))


summary(glm(df$AF ~ prs[rownames(df), 'func'],
            family = binomial()))





tsls(y = phenoTab$af, X = phenoTab$laaef, Z = prs[as.character(phenoTab$IID), 'laaef'],
     w = 1)

