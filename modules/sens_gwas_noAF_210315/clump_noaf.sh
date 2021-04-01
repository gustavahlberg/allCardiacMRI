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
# convert 2 binary ped
#


#msub -t 1-22 convert2binaryped.pbs


# ---------------------------------------------------------------                                   
#                                                                                                   
# clump gwas's no af
#


pth=${DIR}/results/rtrn_noaf
sumstats=(rntrn_ilamin.bgen.stats.gz rntrn_ilamax.bgen.stats.gz rntrn_laaef.bgen.stats.gz rntrn_lapef.bgen.stats.gz rntrn_latef.bgen.stats.gz)

sumstat=${sumstats[0]}

gwas=clumping_noaf

for sumstat in ${sumstats[@]}; do
    . ${DIR}/clumpGwas.sh ${pth}/${sumstat}
done


# ---------------------------------------------------------------                                   
#                                                                                                   
# clump gwas's no valve
#

pth=${DIR}/results/rntrn_noValve
sumstats=(rntrn_ilamin.bgen.stats.gz rntrn_ilamax.bgen.stats.gz rntrn_laaef.bgen.stats.gz rntrn_lapef.bgen.stats.gz rntrn_latef.bgen.stats.gz)

gwas=clumping_noValve



for sumstat in ${sumstats[@]}; do
    . ${DIR}/clumpGwas.sh ${pth}/${sumstat}
done



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

