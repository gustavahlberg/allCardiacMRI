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
#module load moab


# -----------------------------------------------------------
#
# IOs
#

mkdir -p $DIR/intermediate
data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb
ukbSubset=$DIR/intermediate/ukbMriSubset


ukbMaf=$DIR/intermediate/$(basename ${ukbSubset}).maf
ukbMafHwe=${ukbMaf}.hwe
ukbMafHweReg1=${ukbMafHwe}.reg1
ukbMafHweReg=${ukbMafHwe}.reg
ukbMafHweReg=$DIR/data/$(basename ${ukbSubset}).train
#ukbMafHweRegLd=$DIR/data/$(basename ${ukbSubset}).train

samples=$DIR/data/samplesTrain.txt
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
# - MAF > 0.05%
# - HWE > 1.0e-10
# - MISSINGNESS < 2%
# 


plink --bfile $ukbSubset \
    --maf 0.005 \
    --geno 0.02 \
    --autosome \
    --make-bed \
    --out $ukbMaf


plink --bfile $ukbMaf \
    --hwe 1e-10 \
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

# plink --bfile $ukbMafHweReg --freq
# Rscript freq.R

# plink --bfile ${ukbMafHweReg} --clump inv.frq \
#         --clump-kb 1000 --clump-p1 1 --clump-p2 1 --clump-r2 0.9

# cat plink.clumped | tr -s ' ' | grep -v SNP | cut -f 4 -d " " > clumpSNP.prune.in

# # plink --bfile $ukbMafHweReg \
# #     --indep-pairwise 1000 80 0.9 \
# #     --out trainPrune

# plink --bfile $ukbMafHweReg \
#     --extract clumpSNP.prune.in \
#     --make-bed \
#     --out $ukbMafHweRegLd


#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
