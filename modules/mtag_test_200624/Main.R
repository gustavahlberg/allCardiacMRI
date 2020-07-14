#
#
# Module for twoSample
# unrelated samples
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")


library(data.table)

# ---------------------------------------------
#
# load & format 
#

afgwas2 = read.table("../../data/external_gwas/AF_GWAS_ALLv31_maf0.01.txt.gz",
                stringsAsFactors = F, header = T)

str(afgwas2)

rownames(afgwas2) = afgwas2$MarkerName
rownames(afgwas) = afgwas$rs_dbSNP147



sum(afgwas2$MarkerName %in% afgwas$rs_dbSNP147)
afgwas = afgwas[afgwas$rs_dbSNP147 %in% afgwas2$MarkerName,]
afgwas2 = afgwas2[afgwas2$MarkerName %in% afgwas$rs_dbSNP147,]
afgwas2 = afgwas2[afgwas$rs_dbSNP147,]


idx <- which(nchar(afgwas$A1) > 1 | nchar(afgwas$A2) > 1)
afgwas = afgwas[-idx,]
afgwas2 = afgwas2[afgwas$rs_dbSNP147,]

idx <- which(!(grepl("a|g|c|t", afgwas2$Allele1) | grepl("a|g|c|t", afgwas2$Allele2)))
afgwas2 = afgwas2[-idx,]
afgwas = afgwas[afgwas2$MarkerName,]

sum(afgwas$POS_GRCh37 == afgwas2$pos)


afgwas2[(afgwas2$pos != afgwas$POS_GRCh37),]
afgwas[(afgwas$POS_GRCh37 != afgwas2$pos),]

idx = which(toupper(afgwas2$Allele2) == afgwas$A2 & toupper(afgwas2$Allele1) == afgwas$A1)
afgwas = afgwas[idx,]
afgwas2 = afgwas2[idx,]

all(toupper(afgwas2$Allele2) == afgwas$A2 & toupper(afgwas2$Allele1) == afgwas$A1)


afgwas2$freq <- abs(1 - afgwas$Freq_A2)

afgwas2 = data.frame(CHR = afgwas2$chr,
                    BP = afgwas2$pos,
                    SNP = afgwas2$MarkerName,
                    A1 = toupper(afgwas2$Allele1),
                    A2 = toupper(afgwas2$Allele2),
                    FREQ = afgwas2$freq,
                    BETA = afgwas2$Effect,
                    SE = afgwas2$StdErr,
                    P = afgwas2$P.value,
                    N = 133073,
                    stringsAsFactors = F
)

afgwas2$BP = as.character(as.integer(afgwas2$BP))
write.table(afgwas2,
            sep = "\t",
            file = "data/afgwas.ingrid.tbl",
            row.names = F,
            col.names = T,
            quote = F)



afgwas = fread("../../data/external_gwas/nielsen-thorolfsdottir-willer-NG2018-AFib-gwas-summary-statistics.tbl.gz", 
               stringsAsFactors = F, header = T)
afgwas = data.frame(afgwas, stringsAsFactors = F)

afgwas = afgwas[afgwas$Freq_A2 > 0.01 & afgwas$Freq_A2 < 0.99,]
afgwas = afgwas[-which(afgwas$rs_dbSNP147 == "."),]
afgwas = afgwas[-which(duplicated(afgwas$rs_dbSNP147)),]
afgwas = afgwas[-(which(is.na(afgwas)) %% nrow(afgwas)),]

cesgwas = fread("../../data/external_gwas/MEGASTROKE.4.CES.EUR.out.gz", 
               stringsAsFactors = F, header = T)
cesgwas = data.frame(cesgwas, stringsAsFactors = F)
any(duplicated(cesgwas$MarkerName))

rownames(cesgwas) <- cesgwas$MarkerName

ilamaxgwas = fread("../../data/gwas_results/gwas_rtrn/rntrn_ilamax.bgen.stats.betastd.tsv.gz", 
                stringsAsFactors = F, header = T)


sum(cesgwas$MarkerName %in% ilamaxgwas$SNP)
ilamaxgwas = ilamaxgwas[ilamaxgwas$SNP %in% cesgwas$MarkerName,]
ilamaxgwas = ilamaxgwas[-which(duplicated(ilamaxgwas$SNP)),]

cesgwas = cesgwas[ilamaxgwas$SNP,]
all(cesgwas$MarkerName == ilamaxgwas$SNP)

cesgwas$BP = ilamaxgwas$BP
cesgwas$CHR = ilamaxgwas$CHR


afgwas = data.frame(CHR = afgwas$CHR,
           BP = afgwas$POS_GRCh37,
           SNP = afgwas$rs_dbSNP147,
           A1 = toupper(afgwas$A2),
           A2 = toupper(afgwas$A1),
           FREQ = afgwas$Freq_A2,
           BETA = afgwas$Effect_A2,
           SE = afgwas$StdErr,
           P = afgwas$Pvalue,
           N = 1030836,
           stringsAsFactors = F
           )

cesgwas = data.frame(CHR = cesgwas$CHR,
                     BP = cesgwas$BP,
                     SNP = cesgwas$MarkerName,
                     A1 = toupper(cesgwas$Allele1),
                     A2 = toupper(cesgwas$Allele2),
                     FREQ = cesgwas$Freq1,
                     BETA = cesgwas$Effect,
                     SE = cesgwas$StdErr,
                     P = cesgwas$P.value,
                     N = 413304,
                     stringsAsFactors = F
)



any(is.na(afgwas))


write.table(file = "data/afgwas.nielsen.tbl",
            x = afgwas,
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t")



write.table(file = "data/cesgwas.nielsen.tbl",
            x = cesgwas,
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t")



mtaggwas = fread("~/Downloads/z0la2d7kbv7m0hi_1593002671156cesgwas.nielsen.tbl.gz_1593093419271afgwas.ingrid.tbl.gz_trait_1.txt.gz", 
               stringsAsFactors = F, header = T)

mtaggwas = data.frame(mtaggwas, stringsAsFactors = F)

mtaggwas[which.min(mtaggwas$mtag_pval),]

head(mtaggwas[order(mtaggwas$mtag_pval),], 50)

mtaggwas = mtaggwas[order(mtaggwas$mtag_pval),]

head(mtaggwas[mtaggwas$CHR != 4,], 50)



rownames(cesgwas) <- cesgwas$SNP

afgwas = afgwas[afgwas$rs_dbSNP147 %in% cesgwas$SNP,]
cesgwasmtag = cesgwas

cor(cesgwas[afgwas$rs_dbSNP147,]$BETA, as.numeric(afgwas2$BETA))

cesgwas = data.frame(CHR = mtaggwas$CHR,
                     BP = mtaggwas$BP,
                     SNP = mtaggwas$SNP,
                     A1 = mtaggwas$A1,
                     A2 = mtaggwas$A2,
                     FREQ = mtaggwas$FRQ,
                     BETA = mtaggwas$mtag_beta,
                     SE =  mtaggwas$mtag_se,
                     P = mtaggwas$mtag_pval,
                     N = 622070,
                     stringsAsFactors = F
)



write.table(file = "data/ces_afinrid_gwas.mtag.tbl",
            x = cesgwas,
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t")





