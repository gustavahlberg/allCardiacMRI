#
# get Lead SNPs vs/ sbp gwas
#
# ------------------------------



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4


pthAF=${DIR}/results/
#sumstats=(rntrn_bp15Hgilamax.bgen.stats.gz rntrn_bp15Hgilamin.bgen.stats.gz rntrn_bp15Hglaaef.bgen.stats.gz rntrn_bp15Hglapef.bgen.stats.gz rntrn_bp15Hglatef.bgen.stats.gz)


sumstats=(rntrn_bp10Hgilamax.bgen.stats.gz rntrn_bp10Hgilamin.bgen.stats.gz rntrn_bp10Hglaaef.bgen.stats.gz rntrn_bp10Hglapef.bgen.stats.gz rntrn_bp10Hglatef.bgen.stats.gz)


sumstat=${sumstats[0]}

for sumstat in ${sumstats[@]}; do
    echo $sumstat
    pheno=`(basename ${sumstat%.bgen.stats.gz})`
    pheno=`echo $pheno | sed 's/bp10Hg//'`

    cut -f 3 -d " " ../clumping_200518/results/gwSign_${pheno}_ALL.clumped > ${pheno}_leadSnps.txt


    gzcat ${pthAF}/$sumstat | grep -F -f ${pheno}_leadSnps.txt - > results/${pheno}_sbp_leadSnps.txt
    cat results/${pheno}_sbp_leadSnps.txt | perl -ane 'if($F[15] <= 5e-8){print $_}' > tmp
    mv tmp results/${pheno}_sbp_leadSnps.txt
    


done


