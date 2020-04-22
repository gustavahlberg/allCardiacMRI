#
#
# Run flashPca 
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

mkdir -p results
module load flashpca/2.0



# -----------------------------------------------------------
#
# IOs
#

in=$DIR/genPCA/ukbMriSubset.maf.hwe.reg.ld
out=$DIR/results/ukbMriSubset.FlashPca.txt

# -----------------------------------------------------------
#
# flashPca
#


flashpca --bfile $in \
    --outpc $out \
    --ndim 20 \
    --outload loadings.txt \
    --outmeansd meansd.txt \
    --standx binom2 \
    --div p \
    --numthreads 8 


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

