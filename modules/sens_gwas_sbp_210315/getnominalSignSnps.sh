#
# get all nominal sign SNPs in reported locus
#
# ------------------------------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4


pth=${DIR}/results/
sumstats=(rntrn_bp15Hgilamax.bgen.stats.gz rntrn_bp15Hgilamin.bgen.stats.gz rntrn_bp15Hglaaef.bgen.stats.gz rntrn_bp15Hglapef.bgen.stats.gz rntrn_bp15Hglatef.bgen.stats.gz)


for sumstat in ${sumstats[@]}; do
    echo $sumstat
    pheno=`(basename ${sumstat%.bgen.stats.gz})`
    pheno=`echo $pheno | sed 's/bp15Hg//'`

    cut -f 1  ../clumping_200518/results/Locus_nominalSignSnps_${pheno}.txt > ${pheno}_nominalSignSnps.txt

    gzcat ${pth}/$sumstat | grep -F -f ${pheno}_nominalSignSnps.txt - > results/${pheno}_sbp_locusSnps.txt


done


