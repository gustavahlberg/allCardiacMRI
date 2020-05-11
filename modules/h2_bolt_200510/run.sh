#
#
# run bolt h2 and genetic correlations
# 
# ----------------------------------------------------
#
# configs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load snptest/2.5.2
module load plink2/1.90beta5.4
module load bolt-lmm/2.3.4 
pth=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
mkdir -p modelSnps



# ------------------------------------------------
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)
# rm regions in chr 5 & 11

gunzip ${pth}/ukb_snp_chr8_v2.bim.gz
gunzip ${pth}/ukb_snp_chr6_v2.bim.gz
gunzip ${pth}/ukb_snp_chr11_v2.bim.gz
gunzip ${pth}/ukb_snp_chr5_v2.bim.gz
perl excludeMHC.pl -chr 8
perl excludeMHC.pl -chr 6
perl excludeMHC.pl -chr 11
perl excludeMHC.pl -chr 5
gzip ${pth}/ukb_snp_chr8_v2.bim
gzip ${pth}/ukb_snp_chr6_v2.bim
gzip ${pth}/ukb_snp_chr5_v2.bim
gzip ${pth}/ukb_snp_chr11_v2.bim


cat ukb_snp_chr*_v2.excl.bim | cut -f 2 > modelSnps/modelSnps_MHC_chr8inversion.out



# ----------------------------------------------------
#
# modelSnps
#

bash ./modelSnps.sh
grep -Fxv -f modelSnps/modelSnps_MHC_chr8inversion.out modelSnps/modelSnps.prune.in | wc
grep -Fxv -f modelSnps/modelSnps_MHC_chr8inversion.out \
    modelSnps/modelSnps.prune.in > modelSnps/modelSnps_all.txt



# ----------------------------------------------------
#
# run bolt reml
#


bash boltReml_h2_parser.sh  


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
