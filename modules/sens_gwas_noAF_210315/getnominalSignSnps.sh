#
# get all nominal sign SNPs in reported locus
#
# ------------------------------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4


pthAF=${DIR}/results/rtrn_noaf
pthValve=${DIR}/results/rntrn_noValve
sumstats=(rntrn_ilamin.bgen.stats.gz rntrn_ilamax.bgen.stats.gz rntrn_laaef.bgen.stats.gz rntrn_lapef.bgen.stats.gz rntrn_latef.bgen.stats.gz)



sumstat=${sumstats[0]}

for sumstat in ${sumstats[@]}; do
    echo $sumstat
    pheno=`(basename ${sumstat%.bgen.stats.gz})`

    cut -f 1  ../clumping_200518/results/Locus_nominalSignSnps_${pheno}.txt > ${pheno}_nominalSignSnps.txt


    gzcat ${pthAF}/$sumstat | grep -F -f ${pheno}_nominalSignSnps.txt - > results/${pheno}_noAF_locusSnps.txt

    gzcat ${pthValve}/$sumstat | grep -F -f ${pheno}_nominalSignSnps.txt - > results/${pheno}_noValve_locusSnps.txt


done


