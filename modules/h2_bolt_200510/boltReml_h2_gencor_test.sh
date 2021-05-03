#
#
# test run bolt
#
# ----------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load bolt-lmm/2.3.4 


bgen=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr{1:22}_v3.bgen
sampleFn=${DIR}/../../data/ukbCMR.all.snpTest_200506.sample
exclude=${DIR}/../../data/sample2exclude.all.snpTest_200506.list
phenoFn=${DIR}/../../data/ukbCMR.all.boltlmm_200506.sample
covarFn=${DIR}/../../data/ukbCMR.all.boltlmm_200506.sample
pth=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
modelSnps=${DIR}/modelSnps/modelSnps_all_2.txt

pheno_1=ilamax
pheno_2=ilamin
out=test_ilamax_ilamin


# ----------------------------------------------------
#
# bolt gencor
#


bolt \
    --bed ${pth}/ukb_cal_chr{1:22}_v2.bed \
    --bim ${pth}/ukb_snp_chr{1:22}_v2.bim \
    --fam ${DIR}/ukb43247_cal_chr1_v2_s488288.version.fam \
    --remove ${DIR}/bolt.in_plink_but_not_imputed.FID_IID.448525.txt \
    --remove $exclude.bolt \
    --modelSnps $modelSnps \
    --phenoFile $phenoFn \
    --phenoCol=$pheno_1 \
    --phenoCol=$pheno_2 \
    --covarFile $covarFn \
    --covarCol=imgCenter \
    --covarCol=sex \
    --qCovarCol=age \
    --covarCol=genotyping.array \
    --qCovarCol=PC{1:10} \
    --reml \
    --LDscoresFile=${DIR}/../../data/LDSCORE.1000G_EUR.tab.gz \
    --numThreads=8 2>&1 | tee ${DIR}/results/${out}.log


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
