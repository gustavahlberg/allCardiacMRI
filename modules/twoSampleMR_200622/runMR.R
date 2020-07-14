#
#
# run MR
#
# ---------------------------------------------
#
# files
#

laphenos.fns = list.files("../../data/gwas_results/gwas_rtrn", 
                      pattern = "bgen.stats.betastd.tsv.gz",
                      full.names = T)
extneralGwas = data.frame(AF = "../../data/external_gwas/AF_GWAS_ALLv31_maf0.01.txt.gz",
                          AS = "../../data/external_gwas/MEGASTROKE.1.AS.EUR.out.gz",
                          AIS = "../../data/external_gwas/MEGASTROKE.2.AIS.EUR.out.gz",
                          CES = "../../data/external_gwas/MEGASTROKE.4.CES.EUR.out.gz",
                          HF = "../../data/external_gwas/HERMES_Jan2019_HeartFailure_summary_data.txt.gz",
                          stringsAsFactors = F
)

AF_stroke_var = c(" ", "MarkerName", "Effect", "StdErr", "Allele1", "Allele2", "P.value")
HFvar = c(" ", "SNP", "b","se", "A1", "A2", "p")
NextGwas = c(133073,446696,440328,413304,964057)
names(NextGwas) = c("AF","AS","AIS","CES", "HF")

mranalysis = list()
N = 35648
pvalthres = 5e-7

# ---------------------------------------------
#
# la phenos
#

source("runLaPhenosMR.R")


# ---------------------------------------------
#
# ext phenos
#


source("runExtPhenosMR.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
