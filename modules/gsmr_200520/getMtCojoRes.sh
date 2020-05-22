# 
# 6.  get res. from mtcojo in sign loci
#
# -----------------------------------------------------------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

mkdir -p ${DIR}/signSnpMtCojo

# -----------------------------------------------------------


for clumped in `find ${DIR}/../clumping_200518/results/gwSign_rntrn_*_ALL.clumped`;
do

    pheno=$(basename ${clumped%_ALL.clumped})
    pheno=${pheno#gwSign_}
    echo $pheno

    cma=$DIR/mtCojoResults/${pheno}_condAF.mtcojoRes.mtcojo.cma

    cat $clumped | cut -f 3 -d " " | perl -ane 'chomp;print "$_\t\n"' > ${DIR}/signSnpMtCojo/${pheno}_signSNP.txt

    cat ${cma} | grep -F -f  ${DIR}/signSnpMtCojo/${pheno}_signSNP.txt - \
        > ${DIR}/signSnpMtCojo/${pheno}_AF.condsignSNP.txt

    cma=$DIR/mtCojoResults/${pheno}_condHF.mtcojoRes.mtcojo.cma
    cat ${cma} | grep -F -f  ${DIR}/signSnpMtCojo/${pheno}_signSNP.txt - \
        > ${DIR}/signSnpMtCojo/${pheno}_HF.condsignSNP.txt


done



#####################################
# EOF # EOF # EOF # EOF # EOF # EOF #
#####################################
