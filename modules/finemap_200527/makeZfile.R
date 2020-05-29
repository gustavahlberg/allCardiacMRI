#
# make z file
#
# -----------------------------

library(data.table)
library(survey)
library(gsmr)

rntrn_la.list = c("rntrn_lamin.bgen.stats.gz",
                  "rntrn_lamax.bgen.stats.gz",
                  "rntrn_ilamin.bgen.stats.gz",
                  "rntrn_ilamax.bgen.stats.gz",
                  "rntrn_laaef.bgen.stats.gz",
                  "rntrn_lapef.bgen.stats.gz",
                  "rntrn_latef.bgen.stats.gz")
rntrn_la.list = paste0("../gwas_w_bolt_v2_200420/results/gwas_rtrn/", rntrn_la.list)
clpPath = "../clumping_200518/results/"


sumstat.fn = "../gwas_w_bolt_v2_200420/results/gwas_regular/lapef.bgen.stats.gz"


for(i in 1:length(rntrn_la.list)) {


    sumstat.fn = rntrn_la.list[i]
    pheno = gsub(".bgen.stats.gz","",basename(sumstat.fn))
    clump.fn = paste0(clpPath, "gwSign_", pheno,"_ALL.clumped") 


    sumstat = fread(sumstat.fn,
                    stringsAsFactors = F,
                    header = T
                    )

    loci = fread(clump.fn,
                 stringsAsFactors = F,
                 header = T
                 )

    # Standardization of beta
    sumstat$N = 35658
    bzx = sumstat$BETA
    bzx_se = sumstat$SE 
    std_zx = std_effect(snp_freq = sumstat$A1FREQ,
                        b = bzx,se = bzx_se, n= sumstat$N) 
    sumstat$BETA = std_zx$b
    sumstat$SE = std_zx$se


    for(j in 1:dim(loci)[1]) {

        locus = loci[j,]
        chr = locus$CHR
        start = locus$BP - 0.5e6
        end = locus$BP + 0.5e6
        locigwas = sumstat[sumstat$CHR == chr & sumstat$BP >= start & sumstat$BP <= end ,]
        #locigwas  = locigwas[locigwas$P_BOLT_LMM < 0.1,]
        if(any(duplicated(locigwas$SNP))){

            idxDup = which(duplicated(locigwas$SNP))
            locigwas = locigwas[-idxDup,]
        }
        
        #old
        #rsid = gsub("\\([1-9]\\)","",unlist(strsplit(locus$SP2,",")))
        #rsid = c(locus$SNP, rsid)
        #locigwas = sumstat[sumstat$SNP %in% rsid,]
        
        locigwas$A1FREQ[locigwas$A1FREQ > 0.5]  <- 1 - locigwas$A1FREQ[locigwas$A1FREQ > 0.5]

        zSet = data.frame(rsid = locigwas$SNP,
                          chromosome = locigwas$CHR,
                          position = locigwas$BP,
                          allele1 = locigwas$ALLELE1,
                          allele2 = locigwas$ALLELE0,
                          maf = locigwas$A1FREQ,
                          beta = locigwas$BETA,
                          se = locigwas$SE)

        chr=zSet$chromosome[1]
        dataset.fn=paste0("data/",pheno,"_", j,".chr",chr,".z")

        write.table(file = dataset.fn,
                    x = zSet,
                    sep = " ",
                    col.names = T,
                    row.names = F,
                    quote = F
                    )
    }

}







