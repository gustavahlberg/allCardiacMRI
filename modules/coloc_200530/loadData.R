# 
#
# Load data
#
# ---------------------------------------------
#
# files
#

locus.fns = list.files("../finemap_200527/data", full.names = T)
eqtls.fns = list.files("data/GTEx_Analysis_v8_eQTL", 
                       pattern = "signif_variant_gene_pairs.txt.gz",
                       full.names = T)


# ---------------------------------------------
#
# load loci
#

loci = list()

for(locus.fn in locus.fns) {

  pheno = gsub(".z","",basename(locus.fn))
  locus = read.table(locus.fn,
                     stringsAsFactors = F,
                     header = T)
  loci[[pheno]] <- locus
}

tmp = do.call(rbind,loci)
tmp2 = unique(paste(tmp$chromosome, tmp$position, sep = "_"))

# ---------------------------------------------
#
# load lockup
#


lookup.fn = "data/GTEx_Analysis_2017-06-05_v8_WholeGenomeSeq_838Indiv_Analysis_Freeze.lookup_table.txt"
lookup = fread(lookup.fn,
               stringsAsFactors = F,
               header = T)



idxchrPosb37 = which(gsub("(.+_.+)_.+_.+_b37","\\1",lookup$variant_id_b37) %in% tmp2)
idxRsidb37 = which(lookup$rs_id_dbSNP151_GRCh38p7 %in% unique(tmp$rsid))

lookup2 = lookup[unique(idxchrPosb37),]
lookup = lookup[unique(idxRsidb37),]
      
lookup2[!lookup2$variant_id_b37 %in% lookup$variant_id_b37 ,]

variant_id_b37 = gsub("_b37","",lookup2$variant_id_b37, "_")

snpid_A1A2 = paste(tmp$chromosome, tmp$position, tmp$allele1, tmp$allele2, sep = "_")
snpid_A2A1 = paste(tmp$chromosome, tmp$position, tmp$allele2, tmp$allele1, sep = "_")


idxsnpid_A1A2 = which(variant_id_b37 %in% snpid_A1A2)
idxsnpid_A2A1 = which(variant_id_b37 %in% snpid_A2A1)

variant_id_b37match = variant_id_b37[unique(c(idxsnpid_A1A2, idxsnpid_A2A1))]


lookup2 = data.frame(lookup2, stringsAsFactors = F)
lookupMatch = lookup2[gsub("_b37","" ,lookup2$variant_id_b37) %in% variant_id_b37match,]



# ---------------------------------------------
#
# load eqtls
#

tissues = list()

for(eqtl.fn in eqtls.fns) {
  
  tissue = gsub(".v8.signif_variant_gene_pairs.txt.gz","",basename(eqtl.fn))
  eqtl = read.table(eqtl.fn,
                     stringsAsFactors = F,
                     header = T)
  tissues[[tissue]] <- eqtl

}



# ---------------------------------------------
#
# load gtf
#


txdb <- makeTxDbFromGFF("data/gencode.v26.GRCh38.genes.gtf",
                        organism = "Homo sapiens", 
                        format="gtf")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################







