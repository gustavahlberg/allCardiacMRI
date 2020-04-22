# 
#
# Pca QC's
#
# -----------------------------------------------------------
#
# configs 
#
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 
module load moab

# -----------------------------------------------------------
#
# IOs
#

mkdir -p $DIR/intermediate
data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb
ukbSubset=$DIR/../../data/ukbMriSubset
ukbMaf=$DIR/intermediate/$(basename ${ukbSubset}).maf
ukbMafHwe=${ukbMaf}.hwe
ukbMafHweReg1=${ukbMafHwe}.reg1
ukbMafHweReg=${ukbMafHwe}.reg
ukbMafHweRegLd=$DIR/genPCA/$(basename ${ukbMafHweReg}).ld
ukbMafHweRegLdRnd=${ukbMafHweRegLd}.Rnd
samples=$DIR/../../data/sampleList.all.etn_200419.tsv
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
# - HWE > 1.0e-05
# - MISSINGNESS < 2%
# 

plink --bfile $ukbSubset \
    --maf 0.05 \
    --geno 0.02 \
    --autosome \
    --make-bed \
    --out $ukbMaf


plink --bfile $ukbMaf \
    --hwe 1e-4 \
    --make-bed \
    --out $ukbMafHwe


# -----------------------------------------------------------
#
# Remove regions
#
# - no AT/GC SNPs (strand ambiguous SNPs)
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)
#

Rscript rmRegions.R

plink --bfile $ukbMafHwe \
    --exclude $DIR/rsId_StrAmbInv8MHC.tsv \
    --make-bed \
    --out $ukbMafHweReg1

plink --bfile $ukbMafHweReg1 \
    --exclude 'range' $exlReg \
    --make-bed \
    --out $ukbMafHweReg


# -----------------------------------------------------------
#
# LD trim
#
# plink --bfile data --indep-pairwise 1000 50 0.05 --exclude range exclusion_regions_hg19.txt
#

plink --bfile $ukbMafHweReg \
    --indep-pairwise 1000 50 0.1 \
    --out trainPrune

plink --bfile $ukbMafHweReg \
    --extract trainPrune.prune.in \
    --make-bed \
    --out $ukbMafHweRegLd

# random trim
#Rscript randomTrim.R

#plink --bfile $ukbMafHweRegLd \
#    --extract $DIR/rsId_randTrim.tsv \
#    --make-bed \
#    --out $ukbMafHweRegLdRnd



# -----------------------------------------------------------
#
# Rm intermediate
#

lt $DIR/intermediate
rm $DIR/intermediate/*


#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
