
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load gcta/1.91.0beta 

phenoFile=$1
maFile=${phenoFile%.gz}
pheno=$(basename ${maFile%.gcta.tsv})
bfile=${DIR}/cojo
out=${DIR}/cojoResults/cojoResSentinels_${pheno}
condSnplist=${DIR}/sentinels_${pheno}

#gunzip ${phenoFile}
cut -f3 -d " " ../clumping_200518/results/gwSign_${pheno}_ALL.clumped | \
    grep -v SNP > ${DIR}/sentinels_${pheno}

# -----------------------------------------------------------
#
# gcta cojo --cojo-cond
#


gcta64 --bfile $bfile \
    --maf 0.005 \
    --cojo-file ${maFile} \
    --cojo-slct \
    --cojo-cond $condSnplist \
    --cojo-p 5e-8 \
    --thread-num 10 \
    --out $out



#gzip ${maFile}
