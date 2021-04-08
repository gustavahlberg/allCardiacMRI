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
sumstats=(rntrn_bp10Hgilamax.bgen.stats.gz rntrn_bp10Hgilamin.bgen.stats.gz rntrn_bp10Hglaaef.bgen.stats.gz rntrn_bp10Hglapef.bgen.stats.gz rntrn_bp10Hglatef.bgen.stats.gz)


sumstat=${sumstats[1]}
gwas=clumping_sbpAdj

for sumstat in ${sumstats[@]}; do
    . ${DIR}/clumpGwas.sh ${pth}/${sumstat}
done

sumstat=${pth}/${sumstat}

#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

