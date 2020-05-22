
library(xlsx)
library(dplyr)
require(reshape2)

tmp = read.xlsx("../../doc/manuscript/Version_2/Table 3 Lead SNPs.xlsx",
          sheetIndex = 1,
          endRow = 7)


melt(tmp, id.vars="Locus.name")
     
t(tmp)


tmp = t(tmp)
write.xlsx(tmp,
           sheetName = "transformed",
           append = T,
           file = "../../doc/manuscript/Version_2/Table 3 Lead SNPs.xlsx",
          
)
          