#                                                                                                   
# clumping variants                                                                                 
# date: 210323
# ------------------------------------------------------------                                      
#                                                           
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4


# ---------------------------------------------------------------                                   
#                                                                                                   
# clump gwas's sbp adj
#


pth=${DIR}/results/
sumstats=(rntrn_bp15Hgilamax.bgen.stats.gz rntrn_bp15Hgilamin.bgen.stats.gz rntrn_bp15Hglaaef.bgen.stats.gz rntrn_bp15Hglapef.bgen.stats.gz rntrn_bp15Hglatef.bgen.stats.gz)

sumstat=${sumstats[0]}

gwas=clumping_sbpAdj

for sumstat in ${sumstats[@]}; do
    . ${DIR}/clumpGwas.sh ${pth}/${sumstat}
done



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

