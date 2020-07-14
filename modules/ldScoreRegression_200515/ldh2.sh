# 
#
# LD Heritability
#
# ---------------------------------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"

pyenv global anaconda3-4.1.1/envs/ldsc
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA=${HOME}/RESOURCES/pheweb
PATH=$PATH:${HOME}/src/ldsc 
ladir=$DIR/../ldScoreRegression_200515/sumstats/gwas_rtrn/



for pheno in `find ${ladir}/*.sumstats.gz` 
do
    out=$(basename ${pheno%.bgen.stats.sumstats.gz})
    #echo $pheno
    echo $out
    ldsc.py \
        --h2 $pheno\
        --ref-ld-chr ${DIR}/data/eur_w_ld_chr/ \
        --w-ld-chr ${DIR}/data/eur_w_ld_chr/ \
        --out ${out}_h2
done


cat *h2.log | grep -E "Lambda|Mean|Intercept|Ratio"

grep --with-filename -E "Lambda|Mean|Intercept|Ratio" *h2.log | \
    tr ":" "\t" > h2.tab


Rscript reformat_h2_tab.R
