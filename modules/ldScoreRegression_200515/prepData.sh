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


#### fast edit 
ladir=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn
module unload R
module load anaconda2/4.4.0 
module load  ldsc/20200725

# ------------------------------------------------------
#
# gwas_rntrn
#

find ${ladir}/*gz
mkdir -p ${DIR}/sumstats/gwas_rtrn
outDir=${DIR}/sumstats/gwas_rtrn
N=35658

for i in `find ${ladir}/*bgen.stats.gz` 
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
        --merge-alleles w_hm3.snplist

done


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
