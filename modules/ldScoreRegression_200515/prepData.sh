#!/bin/bash
#
# Prep summary stats data before LD analysis
#
# -----------------------------------------------
#
#  configs
#

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"

pyenv global anaconda3-4.1.1/envs/ldsc
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA=${HOME}/RESOURCES/pheweb
PATH=$PATH:${HOME}/src/ldsc 
ladir=$DIR/../../data/gwas_results/gwas_rtrn  


# ------------------------------------------------------
#
# gwas_rntrn
#

find ${ladir}/*gz
mkdir -p ${DIR}/sumstats/gwas_rtrn
outDir=${DIR}/sumstats/gwas_rtrn
N=35658

for i in `find ${ladir}/*gz` 
do

    echo $outDir/"$(basename $i)"
    out=$outDir/"$(basename ${i%.gz})"
    echo $out
    
    munge_sumstats.py \
        --sumstats ${i} \
        --a1 ALLELE1 \
        --a2 ALLELE0 \
        --signed-sumstats BETA,0 \
        --out $out \
        --snp SNP \
        --p P_BOLT_LMM \
        --N $N \
        --merge-alleles w_hm3.noMHC.snplist

done


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
