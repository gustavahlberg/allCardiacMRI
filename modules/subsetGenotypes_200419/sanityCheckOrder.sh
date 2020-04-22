module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


i=1
pth="/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474"
file=${pth}/"ukb_imp_chr"${i}"_v3.bgen"
rs=${DIR}/sanityCheck/rsIds.txt 
sampleData="/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample"
samples=${DIR}/"../../data/sampleList.etn_200219.tsv"
out=${DIR}/sanityCheck/test


bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -incl-samples $samples \
    -og $out \
    -ofiletype binary_ped

plink --bfile $out --recode --tab --out $out



out=${DIR}/sanityCheck/test2
sampleData=${DIR}/../../data/ukbCMR.ordered.etn_200219.sample
file=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr1_v3.bgen
bgenix -g ${file} -index
bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -og $out \
    -ofiletype binary_ped


plink --bfile $out --recode --tab --out $out




# TTN var 

rs=${DIR}/sanityCheck/rsTTN.txt
out=${DIR}/sanityCheck/ttnvar
sampleData=${DIR}/../../data/ukbCMR.ordered.etn_200219.sample
file=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr2_v3.bgen
bgenix -g ${file} -index
bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -og $out \
    -ofiletype binary_ped


plink --bfile $out --recode AD --out $out




# ANKDR1 rs9664170 var 
rs=${DIR}/sanityCheck/rs9664170.txt
out=${DIR}/sanityCheck/rs9664170
sampleData=${DIR}/../../data/ukbCMR.ordered.etn_200219.sample
file=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr10_v3.bgen
bgenix -g ${file} -index
bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -og $out.dosage \
    -ofiletype bimbam_dosage

bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -og $out \
    -ofiletype binary_ped

plink --bfile $out --recode AD --out $out




# MYO18B, rs133885
rs=${DIR}/sanityCheck/rs133885.txt
out=${DIR}/sanityCheck/rs133885
sampleData=${DIR}/../../data/ukbCMR.ordered.etn_200219.sample
file=${DIR}/../../data/subsetFinal/subsetFinal_ukb_imp_chr22_v3.bgen
bgenix -g ${file} -index
bgenix -g ${file} -incl-rsids ${rs} | \
    qctool -g - -filetype bgen \
    -s $sampleData \
    -og $out.dosage \
    -ofiletype bimbam_dosage













