#
# print tables
#
# ------------------------------

library(xlsx)



gencormat[lower.tri(gencormat)] <- phenocorrMatSE[lower.tri(gencormat)]


write.xlsx(x = gencormat,
           file = "../../results/tables/supplementaryTables.xlsx",
           sheetName = "lowtriPheno_UpTriGen_cormat",
           col.names = T,
           row.names = T
           )
