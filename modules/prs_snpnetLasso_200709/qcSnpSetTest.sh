# 
#
# QC snpset Test
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
# IOs
#

mkdir -p $DIR/intermediate
data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb
ukbSubset=$DIR/intermediate/ukbMriSubset
ukbTest=$DIR/data/$(basename ${ukbSubset}).test

samples=$DIR/data/samplesTest.txt
exlReg=$DIR/exclusion_regions_hg19.txt


# -----------------------------------------------------------
#
# subset 
#

plink --bfile $ukb \
    --keep-fam $samples \
    --make-bed \
    --out $ukbSubset


cut -f 2 $DIR/data/ukbMriSubset.train.bim > snps.in

plink --bfile $ukbSubset \
    --extract snps.in \
    --make-bed \
    --out $ukbTest


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
