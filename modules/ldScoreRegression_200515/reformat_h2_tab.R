library(reshape2)
library(xlsx)
tab = read.table("h2.tab",
                 sep  = "\t",
                 stringsAsFactors = F)


tab = acast(tab, V1 ~ V2 , value.var = 'V3')


write.table(tab,
            file = "h2_reformat.tab",
            sep = "\t",
            row.names = T,
            col.names = T,
            quote = F)


write.xlsx(tab,
           file = "h2_reformat.xlsx",
           sheetName =   '1',
           row.names = T,
           col.names = T)









