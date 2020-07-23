# 
#
# QC snpset Training
#
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 

# -----------------------------------------------------------
#
# io's
#


intrain=${DIR}/data/ukbMriSubset.train
intest=${DIR}/data/ukbMriSubset.test


# -----------------------------------------------------------
#
# train
#


plink2 --bfile $intrain \
       --make-pgen vzs \
       --out $intrain


# -----------------------------------------------------------
#
# test
#

plink2 --bfile $intest \
       --make-pgen vzs \
       --out $intest


