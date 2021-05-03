# ---------------------------------------------
#
# make table
#
# ---------------------------------------------

table <- list()

for(pheno in phenos) {

  table[[pheno]] <- data.frame(PVE = 100*pve_trait[[pheno]],
                               fstat = gwas_fstat[[pheno]])
}



table <- do.call(rbind,table)

rownames(table)  <- gsub("\\.", " ", rownames(table))


table <- signif(table, digits = 3)

write.table(table,
            file = "PVE_percentage.tsv",
            sep = " ",
            col.names = T,
            row.names = T,
            quote = F)

