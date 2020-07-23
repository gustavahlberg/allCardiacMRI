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


ukbSubsetRel=$DIR/intermediate/$(basename ${ukbSubset}).rel
ukbSubsetUnRel=$DIR/intermediate/$(basename ${ukbSubset}).unrel


ukbMaf=$DIR/intermediate/$(basename ${ukbSubsetUnRel}).maf
ukbMafHwe=${ukbMaf}.hwe
ukbMafHweReg1=${ukbMafHwe}.reg1
ukbMafHweReg=${ukbMafHwe}.reg
ukbMafHweRegLd=$DIR/genPCA/$(basename ${ukbMafHweReg}).ld
ukbMafHweRegLdRnd=${ukbMafHweRegLd}.Rnd
ukbSubsetRelLd=$DIR/genPCA/$(basename ${ukbSubsetRel}).ld

samples=$DIR/../../data/sampleList.all.etn_200506.tsv
exlReg=$DIR/exclusion_regions_hg19.txt
rel4th=$DIR/results/related4_dgrs_200507.txt


# -----------------------------------------------------------
#
# split -> unrelated, related
#

plink --bfile $ukbSubset --remove-fam $rel4th  --make-bed --out $ukbSubsetUnRel
plink --bfile $ukbSubset --keep-fam $rel4th  --make-bed --out $ukbSubsetRel


# -----------------------------------------------------------
#
# Select snps
#
# - MAF > 5%
# - HWE > 1.0e-04
# - MISSINGNESS < 2%
# 

plink --bfile $ukbSubsetUnRel \
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

Rscript rmRegions.R ${ukbMafHwe}.bim

plink --bfile $ukbMafHwe \
    --exclude $DIR/rsId_StrAmb.tsv \
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
    --indep-pairwise 1000 80 0.1 \
    --out trainPrune

plink --bfile $ukbMafHweReg \
    --extract trainPrune.prune.in \
    --make-bed \
    --out $ukbMafHweRegLd


# -----------------------------------------------------------
#
# Related dataset subet SNPs
#


plink --bfile $ukbSubsetRel \
    --extract trainPrune.prune.in \
    --make-bed \
    --out $ukbSubsetRelLd



# -----------------------------------------------------------
#
# Rm intermediate
#

lt $DIR/intermediate
rm $DIR/intermediate/*


#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
