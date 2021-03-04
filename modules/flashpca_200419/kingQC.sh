# 
#
# King QC's
#
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 
module load moab
module load king/2.1.3

# -----------------------------------------------------------
#
# IOs
#

mkdir -p $DIR/intermediate
data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb
ukbSubset=$DIR/../../data/ukbMriSubset
ukbMaf=$DIR/intermediate/$(basename ${ukbSubset}).maf
ukbMafReg1=${ukbMaf}.reg1
ukbMafReg=${ukbMafReg1}.reg
samples=$DIR/../../data/sampleList.all.etn_200506.tsv
exlReg=$DIR/exclusion_regions_hg19.txt


# -----------------------------------------------------------
#
# subset 
#

plink --bfile $ukb \
    --keep-fam $samples \
    --make-bed \
    --out $ukbSubset



# -----------------------------------------------------------
#
# Select snps
#
# - MAF > 5%
# - MISSINGNESS < 2%
# 

plink --bfile $ukbSubset \
    --maf 0.01 \
    --geno 0.02 \
    --autosome \
    --make-bed \
    --out $ukbMaf


# -----------------------------------------------------------
#
# Remove regions
#
# - no AT/GC SNPs (strand ambiguous SNPs)
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)
#

Rscript rmRegions.R intermediate/ukbMriSubset.maf.bim

plink --bfile $ukbMaf \
    --exclude $DIR/rsId_StrAmb.tsv \
    --make-bed \
    --out $ukbMafReg1

plink --bfile $ukbMafReg1 \
    --exclude 'range' $exlReg \
    --make-bed \
    --out $ukbMafReg


# -----------------------------------------------------------
#
# Rm intermediate
#

#lt $DIR/intermediate
#rm $DIR/intermediate/*


#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
