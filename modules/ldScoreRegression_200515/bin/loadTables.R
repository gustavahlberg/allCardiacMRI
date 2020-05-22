#
#
# load table & libs
#
# ---------------------------------------------------
#
# list files
#

files = list.files(path = "results", pattern = "log", full.names = T)


# ---------------------------------------------------
#
# load tables
#

genCor = list()

for(i in 1:length(files)) {
  
  #i = 5
  file = files[i]
  cmd = paste("head -n +1500", file ,"| grep -in 'Summary of Genetic Correlation Results'")
  sof = system(cmd, intern = T)
  sof = as.numeric(gsub(":.+","",sof))
  cmd = paste("head -n +1500", file ,"| grep -in 'Analysis finished at'")
  eof = system(cmd, intern = T)
  eof = as.numeric(gsub(":.+","",eof))
  
  tab = read.table(file = file,
                   skip = as.numeric(sof),
                   nrows = eof - sof -3,
                   header = T,
                   sep = "", 
                   stringsAsFactors = F)
  
  # ---------------------------------------------------
  # clean
  
  tab$p1 = gsub("rntrn_","",gsub(".bgen.stats.sumstats.gz","",basename(tab$p1)))
  tab$p2 = gsub("_.+|\\.?(gwas.v3.)?sumstats.gz|\\.?(txt)?.gz.sumstats.gz","",basename(tab$p2))
  tab$p2 = gsub("MEGASTROKE.\\d.|.EUR.out","", tab$p2)
  tab = tab[-c(4:6,12),]
  tab$negLog10 = round(-log10(tab$p),3)
  
  tab$p2 = c("Atrial fibrillation",
             "Body mass index",
             "diastolic bp",
             "Health rating",
             "Heart Failure",
             "Stroke",
             "Ischemic stroke",
             "Cardioembolic stroke",
             "Systolic bp",
             "Type II diabetes"
  )
  
  # ---------------------------------------------------
  # save
  
  genCor[[tab$p1[1]]] <- tab
  
  
}




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
