module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


N=$1
pth=${DIR}/"../../data/subsetbgen"
file=${pth}/subset_ukb_imp_chr${N}_v3.bgen

subsetOut=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr${N}_v3.bgen
qctool -g $file -filetype bgen -bgen-bits 8 -og $subsetOut

