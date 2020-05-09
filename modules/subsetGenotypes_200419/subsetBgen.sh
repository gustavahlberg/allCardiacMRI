module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

arr=(1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22)
N=$1
i=${arr[${N}]}

pth="/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474"
file=${pth}/"ukb_imp_chr"${i}"_v3.bgen"
rs=${DIR}/rsidIncl/rsIds_chr_${i}.txt
sampleData="/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample"
samples=${DIR}/"../../data/sampleList.all.etn_200506.tsv"
out=${DIR}/../../data/subsetbgen/subset_ukb_imp_chr${i}_v3.bgen



# test
# out=${DIR}/testDir/subset_ukb_imp_chr${i}_v3.vcf
# rs=testRs

bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen -s $sampleData \
    -incl-samples $samples -og $out -bgen-bits 8




#qctool -g ${file} -s $sampleData -incl-samples $samples -og $out -incl-rsids ${rs}

#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################

