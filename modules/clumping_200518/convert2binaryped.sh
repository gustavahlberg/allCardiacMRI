module load bgen/20180807
module load lapack/3.6.0
module unload R/4.0.0
module unload gcc/9.3.0
module load gcc/5.4.0
module load qctool/2.0.1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

i=$1


pth=${DIR}/../../data/subsetbgen/
file=${pth}/subset_ukb_imp_chr${i}_v3.bgen
sampleFn=${DIR}/../../data/ukbCMR.rep.snpTest_200509.sample
out=${DIR}/../../data/subsetBinaryPed/subsetFinal_ukb_chr${i}_v3



qctool -g $file -filetype bgen -s $sampleFn \
    -og $out -ofiletype binary_ped 
