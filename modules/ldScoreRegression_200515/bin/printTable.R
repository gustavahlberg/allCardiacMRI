genCorTab = do.call(rbind,genCor)


write.xlsx(x = genCorTab,
           file = "../../results/tables/supplementaryTables.xlsx",
           col.names = T,
           row.names = F,
           sheetName = "Table_X_LDSC_GeneticCorrelation",
           append = T)



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################