#
# get Lead SNPs vs/ noaf gwas
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

    cut -f 3 -d " " ../clumping_200518/results/gwSign_${pheno}_ALL.clumped > ${pheno}_leadSnps.txt


    gzcat ${pthAF}/$sumstat | grep -F -f ${pheno}_leadSnps.txt - > results/${pheno}_noAF_leadSnps.txt
    cat results/${pheno}_noAF_leadSnps.txt | perl -ane 'if($F[15] <= 5e-8){print $_}' > tmp
    mv tmp results/${pheno}_noAF_leadSnps.txt
    
    gzcat ${pthValve}/$sumstat | grep -F -f ${pheno}_leadSnps.txt - > results/${pheno}_noValve_leadSnps.txt
    cat results/${pheno}_noValve_leadSnps.txt | perl -ane 'if($F[15] <= 5e-8){print $_}' > tmp
    mv tmp results/${pheno}_noValve_leadSnps.txt


done


