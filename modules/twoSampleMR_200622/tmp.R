library(biomaRt)
library(data.table)
load("exposureList.Rdata")
rsids <- unique(unlist(lapply(exposureList, function(x) x[,'SNP'])))


snp_mart = useMart(biomart="ENSEMBL_MART_SNP", host="grch37.ensembl.org", 
                   path="/biomart/martservice", 
                   dataset="hsapiens_snp")

listAttributes(snp_mart)
listFilters(snp_mart)
gwas <- fread("COVID.gz", stringsAsFactors = F, header = T, sep = "\t") 

test <- getBM(attributes = c('refsnp_id','allele','chrom_start','chrom_strand','chr_name'), 
              filters = c('snp_filter'),
              values = list(rsids), 
              mart = snp_mart)

df <- data.frame(chr = head(gwas$CHR,2), pos = head(gwas$POS,2)-1, end = head(gwas$POS,2))

test <- getBM(attributes = c('refsnp_id','allele','chrom_start','chr_name'), 
              filters = c('chr_name','start','end'),
              values = list(chr_name = unique(df$chr),start = df$pos, end = df$end),
              mart = snp_mart)


write.table(test,
            file = "exp_rsid_chr_pos.tsv",
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t")

