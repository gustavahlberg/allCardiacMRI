#
#
#  run bolt
#
# ----------------------------------------------------
#
# inputs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load bolt-lmm/2.3.4 


pheno=$1
pheno=$1
sampleFn=${DIR}/../../data/ukbCMR.all.snpTest_200506.sample
phenoFn=${DIR}/../../data/ukbCMR.all.boltlmm_200506.sample
covarFn=${DIR}/../../data/ukbCMR.all.boltlmm_200506.sample
exclude=${DIR}/../../data/sample2exclude.all.snpTest_200506.list
pth=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
modelSnps=${DIR}/modelSnps_all.txt
geneticMap=${DIR}/genetic_map_hg19_withX.txt.gz
bgen=$DIR/../../data/subsetbgen/subset_ukb_imp_chr{1:22}_v3.bgen
outDir=${DIR}/results/gwas_rtrn


# ----------------------------------------------------
#
# bolt lmm
#
# bgen=$DIR/../subsetGenotypes_191108/test.bgen
# pheno=LAV.max.mL
#

bolt \
    --bed ${pth}/ukb_cal_chr{1:22}_v2.bed.gz  \
    --bim ${pth}/ukb_snp_chr{1:22}_v2.bim.gz  \
    --fam ${DIR}/ukb43247_cal_chr1_v2_s488288.version.fam \
    --modelSnps $modelSnps \
    --remove bolt.in_plink_but_not_imputed.FID_IID.448525.txt \
    --remove $exclude.bolt \
    --bgenFile $bgen \
    --sampleFile $sampleFn \
    --phenoFile $phenoFn \
    --phenoCol=$pheno \
    --covarFile $covarFn \
    --qCovarCol=PC{1:10} \
    --lmmForceNonInf \
    --LDscoresFile=${DIR}/../../data/LDSCORE.1000G_EUR.tab.gz \
    --geneticMapFile=$geneticMap \
    --numThreads=8 \
    --bgenMinMAF=5e-3 \
    --bgenMinINFO=0.8 \
    --statsFile=${outDir}/${pheno}.gz \
    --statsFileBgenSnps=${outDir}/${pheno}.bgen.stats.gz \
    --verboseStats


