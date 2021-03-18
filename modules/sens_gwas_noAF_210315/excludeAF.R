# ----------------------------------------------------
#
# exclude AF
#
# ----------------------------------------------------

phenofn <- "../../data/ukbCMR.all.boltlmm_210316.sample"

pheno <- read.table(phenofn,
                    header = T)



sum(pheno$af, na.rm = T)


afcases <- pheno$IID[which(pheno$af == 1)]


df <- data.frame(FID = afcases,
           IID = afcases)

write.table(file = "afcases.list.bolt",
            df,
            col.names = F,
            row.names = F,
            sep = "\t"
            )




valvecases <- pheno$IID[which(pheno$Valve == 1)]


df <- data.frame(FID = valvecases,
                 IID = valvecases)


write.table(file = "valvecases.list.bolt",
            df,
            col.names = F,
            row.names = F,
            sep = "\t"
            )



