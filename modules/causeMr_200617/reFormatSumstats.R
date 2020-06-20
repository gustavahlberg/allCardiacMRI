#
#  HF
#
# ---------------------------

library(data.table)
library(survey)
library(gsmr)

sumstat.fn="../gsmr_200520/data/HERMES_Jan2019_HeartFailure_summary_data.txt.gz"

sumstat = fread(sumstat.fn,
                stringsAsFactors = F,
                header = T
                )


gctaSumstat = data.frame(SNP= sumstat$SNP,
                         A1 = toupper(sumstat$A1),
                         A2 = toupper(sumstat$A2),
                         freq = sumstat$freq,
                         b = sumstat$b,
                         se = sumstat$se,
                         p = sumstat$p,
                         N = sumstat$N,
                         stringsAsFactors = F)


if (any(duplicated(gctaSumstat$SNP))) {
    idxDup = which(duplicated(gctaSumstat$SNP))
    gctaSumstat = gctaSumstat[-idxDup,]
}



write.table(gctaSumstat,
            file = "data/HF_sumstat.gcta.tsv",
            col.names = T,
            row.names = F,
            quote = F)


# ----------------------------------
#
#  AF
#


sumstat.fn="../gsmr_200520/data/AF_GWAS_ALLv31_maf0.01.txt.gz"

sumstat = fread(sumstat.fn,
                stringsAsFactors = F,
                header = T
                )

gctaSumstat = data.frame(SNP= sumstat$MarkerName,
                         A1 = toupper(sumstat$Allele1),
                         A2 = toupper(sumstat$Allele2),
                         b = sumstat$Effect,
                         se = sumstat$StdErr,
                         p = sumstat$P.value,
                         N = 133073,
                         stringsAsFactors = F)

if (any(duplicated(gctaSumstat$SNP))) {
    idxDup = which(duplicated(gctaSumstat$SNP))
    gctaSumstat = gctaSumstat[-idxDup,]
}

write.table(gctaSumstat,
            file = "data/AF_sumstat.gcta.tsv",
            col.names = T,
            row.names = F,
            quote = F)



# ----------------------------------
#
#  Stroke
#

ns = c("446696","440328","413304")
stroke.fn = c("../gsmr_200520/data/MEGASTROKE.1.AS.EUR.out.gz",
              "../gsmr_200520/data/MEGASTROKE.2.AIS.EUR.out.gz",
              "../gsmr_200520/data/MEGASTROKE.4.CES.EUR.out.gz")

out.list = c("data/stroke.AS.EUR.gcta.tsv",
             "data/stroke.AIS.EUR.gcta.tsv",
             "data/stroke.CES.EUR.gcta.tsv")


for(i in 1:length(stroke.fn)) {
    #i = 1
    sumstat.fn = stroke.fn[i]
    N = ns[i]


    sumstat = fread(sumstat.fn,
                    stringsAsFactors = F,
                    header = T
                    )

    
    gctaSumstat = data.frame(SNP = sumstat$MarkerName,
                             A1 = toupper(sumstat$Allele1),
                             A2 = toupper(sumstat$Allele2),
                             freq = sumstat$Freq1,
                             b = sumstat$Effect,
                             se = sumstat$StdErr,
                             p = sumstat$`P-value`,
                             N = N,
                             stringsAsFactors = F)

    if (any(duplicated(gctaSumstat$SNP))) {
        idxDup = which(duplicated(gctaSumstat$SNP))
        gctaSumstat = gctaSumstat[-idxDup,]
    }

    dim(gctaSumstat)
    write.table(gctaSumstat,
                file = out.list[i],
                col.names = T,
                row.names = F,
                quote = F)
}



# ----------------------------------
#
#  LA parameters
#


rntrn_la.list = c("rntrn_lamin.bgen.stats.gz",
                  "rntrn_lamax.bgen.stats.gz",
                  "rntrn_ilamin.bgen.stats.gz",
                  "rntrn_ilamax.bgen.stats.gz",
                  "rntrn_laaef.bgen.stats.gz",
                  "rntrn_lapef.bgen.stats.gz",
                  "rntrn_latef.bgen.stats.gz")
rntrn_la.list = paste0("../gwas_w_bolt_v2_200420/results/gwas_rtrn/", rntrn_la.list)
la.list = rntrn_la.list


for(i in 1:length(la.list)) {

    sumstat.fn = la.list[i]
    out.fn = paste0("data/",gsub(".bgen.stats.gz","",basename(sumstat.fn)),".gcta.tsv")

    sumstat = fread(sumstat.fn,
                    stringsAsFactors = F,
                    header = T
                    )

    gctaSumstat = data.frame(SNP = sumstat$SNP,
                             A1 = toupper(sumstat$ALLELE1),
                             A2 = toupper(sumstat$ALLELE0),
                             freq = sumstat$A1FREQ,
                             b = sumstat$BETA,
                             se = sumstat$SE,
                             p = sumstat$P_BOLT_LMM,
                             N = 35648,
                             stringsAsFactors = F)


    # Standardization
    bzx = gctaSumstat$b     # effects of the instruments on risk factor
    bzx_se = gctaSumstat$se      # standard errors of bzx
    std_zx = std_effect(snp_freq = gctaSumstat$freq,
                        b = bzx,se = bzx_se, n= gctaSumstat$N) 

    gctaSumstat$b = std_zx$b
    gctaSumstat$se = std_zx$se

    if (any(duplicated(gctaSumstat$SNP))) {
        idxDup = which(duplicated(gctaSumstat$SNP))
        gctaSumstat = gctaSumstat[-idxDup,]
    }


    write.table(gctaSumstat,
                file = out.fn,
                col.names = T,
                row.names = F,
                quote = F)
}


