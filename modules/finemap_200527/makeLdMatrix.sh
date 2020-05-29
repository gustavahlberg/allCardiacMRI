#
#
# make ld mats
#
# ----------------------------------------------------


module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#zfile=${DIR}/data/rntrn_ilamax_1.chr1.z
zfile=$1

tmp=$(basename ${zfile%.z})
pheno=${tmp%.chr*}
chr=${tmp#${pheno}.chr}

file=$DIR/../../data/subsetbgen/subset_ukb_imp_chr${chr}_v3.bgen 
rs=rsid_${pheno}
sampleData=${DIR}/../../data/ukbCMR.all.snpTest_200506.sample
out=${DIR}/bimbam/${pheno}.chr${chr}.dosage


cut -f 1 -d " " $zfile | grep -v 'rsid' > ${rs}

bgenix -g ${file} -index || true
bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen  \
    -og $out -s $sampleData -ofiletype dosage



Rscript ${DIR}/makeLdMatrix.R $out $zfile
