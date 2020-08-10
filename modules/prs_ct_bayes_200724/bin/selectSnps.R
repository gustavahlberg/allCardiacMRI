# ----------------------------------
#
# 1) select snps
#
# ----------------------------------
#
# Load summary stats
#

load("data/sampleData.rda", verbose = T)

rntrnPath='../../../cardiacMRI/modules/gwas_w_bolt_v2_200316/results/gwas_rtrn/rntrn_'
regPath='../../../cardiacMRI/modules/gwas_w_bolt_v2_200316/results//gwas_regular/'

#pheno='ilamax'

regGwas.fn = paste0(regPath,pheno,'.bgen.stats.gz')
rntrnGwas.fn = paste0(rntrnPath,pheno,'.bgen.stats.gz')

regGwas = fread2(regGwas.fn,
                 select = c("SNP","CHR", "BP", "ALLELE0", "ALLELE1",
                            "A1FREQ","BETA","SE","P_BOLT_LMM"),
                 col.names = c("snp","chr", "bp", "a0", "a1",
                               "a1f","beta","se","p"))

rntrnGwas = fread2(rntrnGwas.fn,
                 select = c("SNP","CHR", "BP", "ALLELE0", "ALLELE1",
                            "A1FREQ","BETA","SE","P_BOLT_LMM"),
                 col.names = c("snp","chr", "bp", "a0", "a1",
                               "a1f","beta","se","p"))

all(rntrnGwas$snp == regGwas$snp)

regGwas$p <- rntrnGwas$p
rm(rntrnGwas)

#subset to p < 0.05 & maf < 1%
regGwas <- regGwas[which(regGwas$p < 0.01),]
regGwas <- regGwas[-which(regGwas$a1f > 0.99 | regGwas$a1f < 0.01),]
dim(regGwas)

# exclude regions 6 25000000 33500000 r2 8 7000000 13000000 r3
regGwas = regGwas[-which(regGwas$chr == 6 & regGwas$bp > 25e6 & regGwas$bp < 33.5e6),]
regGwas = regGwas[-which(regGwas$chr == 8 & regGwas$bp > 7e6 & regGwas$bp < 13e6),]


list_snp_id <- with(regGwas, split(paste(chr, bp, a1, a0, sep = "_"),
                                    factor(chr, levels = 1:22)))



# -------------------------
# 
# make big snpr matrix
#
# ------------------------


backingfile = paste0("data/",pheno)

system.time(
  rds <- bigsnpr::snp_readBGEN(
    bgenfiles = glue::glue("../../data/subsetbgen/subset_ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
    list_snp_id = list_snp_id,
    backingfile = backingfile,
    ind_row = ind.indiv,
    bgi_dir = "../../data/subsetbgen/",
    ncores = 10
  )
) # 2H


save(regGwas, list_snp_id, file = paste0("data/snpgwasdata_", pheno,".rda"))


###########################################
# Eof # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
