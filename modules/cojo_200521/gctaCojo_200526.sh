
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load gcta/1.91.0beta 

phenoFile=$1
#gunzip ${phenoFile}
maFile=${phenoFile%.gz}

pheno=$(basename ${maFile%.gcta.tsv})

bfile=${DIR}/cojo
out=${DIR}/cojoResults/cojoRes_${pheno}

gcta64 --bfile $bfile \
    --maf 0.005 \
    --cojo-file ${maFile} \
    --cojo-slct \
    --cojo-p 5e-8 \
    --cojo-collinear 0.9 \
    --thread-num 10 \
    --out $out


#gzip $maFile
