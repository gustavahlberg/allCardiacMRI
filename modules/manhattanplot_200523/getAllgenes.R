listMarts()
ensembl=useMart("ensembl", host="grch37.ensembl.org")
listDatasets(ensembl)
mart = useDataset(dataset = "hsapiens_gene_ensembl",mart=ensembl)

listFilters(mart)[grep("biotype",listFilters(mart)$name),]
filterOptions("biotype", mart)
listAttributes(mart)[grep("start",listAttributes(mart)$name),]
listAttributes(mart)[grep("chr",listAttributes(mart)$name),]
listAttributes(mart)[grep("gene",listAttributes(mart)$name),]

res = getBM(attributes=c("chromosome_name",
                         "start_position",
                         "end_position",
                         "strand",
                         "ensembl_gene_id",
                         "external_gene_name",
                         "gene_biotype",
                         "external_gene_source",
                         "description"),
            filters='biotype', 
            #values=c('protein_coding','miRNA'),
            values=c('protein_coding'),
            mart=mart)
dim(res)
head(res)
sum(res$chromosome_name %in% 1:22)
res = res[which(res$chromosome_name %in% 1:22),]

res$strand = ifelse(res$strand == 1, '+','-')

res$SIZE = abs(res$start_position - res$end_position)

genelist = res
colnames(genelist) = c("CHR","START","END","STRAND","ensembl_gene_id",
                       "GENE","gene_biotype","external_gene_source","description","SIZE")
rm(res)

