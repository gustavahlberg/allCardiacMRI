#
# mtcojo
#
# ---------------------------------------------
#
# load files
#

cols = c("SNP","A1","A2","freq","b","se","p","N","bC","bC_se","bC_pval","pheno","condPheno" )
mtCojoTab = matrix(,ncol = length(cols), dimnames = list(c(""),cols))
mtCojoTab = data.frame(mtCojoTab[-1,], stringsAsFactors = F)

files.fn = list.files("signSnpMtCojo", pattern = "condsignSNP.txt", full.names = T)

for(file.fn in files.fn){
  print(file.fn)
  tmp = unlist(strsplit(gsub("rntrn_|.condsignSNP.txt","",basename(file.fn)), "_"))
  pheno = tmp[1]
  condPheno = tmp[2]
  
  condTab = read.table(file = file.fn,
                       header = T,
                       stringsAsFactors = F)
  
  condTab$A2 = as.character(condTab$A2)
  condTab[,"pheno"] <- pheno
  condTab[,"condPheno"] <- condPheno
  
  mtCojoTab = rbind(mtCojoTab,condTab)
  
}


mtCojoTab$A2[mtCojoTab$A2 == "TRUE"] <- "T"

mtCojoTab = mtCojoTab[-which(mtCojoTab$SNP == "rs7842765"),]

# ---------------------------------------------
#
# format tab
#



cols = c("SNP","A1","A2","freq","b","se","p","N","bC","bC_se","bC_pval","pheno","condPheno" )
colsNonCond = c("SNP","b","se","p","pheno")
colsCond = c("SNP","bC","bC_se","bC_pval","pheno", "condPheno")

mtCojoTabNone = mtCojoTab[mtCojoTab$condPheno == "HF",colsNonCond]
mtCojoTabNone[,'condPheno'] <- "None"
mtCojoTabCond = mtCojoTab[,colsCond]
colnames(mtCojoTabCond) <- c("SNP","b","se","p","pheno","condPheno")

mtCojoTab = rbind(mtCojoTabNone , mtCojoTabCond)




# ---------------------------------------------
#
# Plot
#


mtCojoTab = mtCojoTab[order(mtCojoTab$SNP, mtCojoTab$pheno, mtCojoTab$condPheno),]
mtCojoTab$pheno = toupper(mtCojoTab$pheno)
mtCojoTab$pheno[mtCojoTab$pheno == "ILAMIN"] = "iLAmin"
mtCojoTab$pheno[mtCojoTab$pheno == "ILAMAX"] = "iLAmax"
mtCojoTab$pheno[mtCojoTab$pheno == "LAMIN"] = "LAmin"
mtCojoTab$pheno[mtCojoTab$pheno == "LAMAX"] = "LAmax"


mtCojoTabVol = mtCojoTab[grep("max|min",mtCojoTab$pheno),]
mtCojoTabFunc = mtCojoTab[-grep("max|min",mtCojoTab$pheno),]


# La volume plot 
source("bin/LaVolplotMtCojo.R")

# La function plot 
source("bin/LaFuncplotMtCojo.R")


# La all plot 
source("bin/LaAllplotMtCojo.R")


write.xlsx(mtCojoTab,
           "mtCojoResults.xlsx",
           row.names = F)




