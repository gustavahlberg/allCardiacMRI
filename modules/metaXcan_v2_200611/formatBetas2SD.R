#
# Reformat beta in rtrn to SD units
#
# ----------------------------------
#
#  LA parameters
#

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



for(i in 1:length(rntrn_la.list)) {

    sumstat.fn = rntrn_la.list[i]
    out.fn = gsub("gz","betastd.tsv", sumstat.fn)

    sumstat = fread(sumstat.fn,
                    stringsAsFactors = F,
                    header = T
                    )
    # Standardization
    sumstat$N = 35648
    bzx = sumstat$BETA     # effects of the instruments on risk factor
    bzx_se = sumstat$SE      # standard errors of bzx
    std_zx = std_effect(snp_freq = sumstat$A1FREQ,
                        b = bzx,se = bzx_se, n = sumstat$N) 

    sumstat$bstd = std_zx$b
    sumstat$sestd = std_zx$se

    write.table(sumstat,
                file = out.fn,
                col.names = T,
                row.names = F,
                quote = F,
                sep = "\t")


}
