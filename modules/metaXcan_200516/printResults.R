
files = list.files("results", full.names = T)


for(i in 1:length(files)) {

  file = files[i]
  results = read.csv(file)
  
  resNomSign = results[results$pvalue < 0.05,]
  
  if(grepl("_la",file)){
    sheetname = paste0(gsub("la.txt","",basename(file)),"AA_MetaXcan_nominalSignficant")
  } else {
    sheetname = paste0(gsub("lv.txt","",basename(file)),"LV_MetaXcan_nominalSignficant")
  }
  
  write.xlsx(resNomSign,
             file = "../../results/tables/supplementaryTables.xlsx",
             col.names = T,
             row.names = F,
             append = TRUE,
             sheetName = sheetname)
  
}
