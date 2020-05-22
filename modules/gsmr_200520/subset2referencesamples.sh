# 
#
# 2. subset genotypes to 12,000 sample set
#
# -----------------------------------------------------------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module  load plink2/1.90beta5.4
mkdir -p ${DIR}/subsetGenotypes

inpth=${DIR}/../../../AFGRS/modules/cojoAnalysis_191010/subsetGenotypes
outpth=${DIR}/subsetGenotypes
refSamples=${DIR}/../../data/refsamplesGSMR.tsv


for i in {1..22}
do
    echo "running chr $i"
    plink --bfile ${inpth}/cojo_${i} \
        --keep-fam $refSamples \
        --make-bed \
        --out ${outpth}/cojo_${i}
done


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
