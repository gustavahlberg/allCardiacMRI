#                                                                                                   
# clumping variants                                                                                 
# date: 200519
# ------------------------------------------------------------                                      
#                                                           
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


mkdir -p ../../data/subsetBinaryPed/
module load plink2/1.90beta5.4
module load moab

# ---------------------------------------------------------------                                   
#                                                                                                   
# convert 2 binary ped
#


msub -t 1-22 convert2binaryped.pbs


# ---------------------------------------------------------------                                   
#                                                                                                   
# clump gwas's
#

pth=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn
sumstats=(rntrn_ilamin.bgen.stats.gz rntrn_ilamax.bgen.stats.gz rntrn_lamin.bgen.stats.gz rntrn_lamax.bgen.stats.gz rntrn_laaef.bgen.stats.gz rntrn_lapef.bgen.stats.gz rntrn_latef.bgen.stats.gz)


for sumstat in ${sumstats[@]}; do
    . ${DIR}/clumpGwas.sh ${pth}/${sumstat}
done

#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

