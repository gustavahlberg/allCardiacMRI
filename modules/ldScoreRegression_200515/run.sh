#
# Run ld score regression analysis
# date: 200515
#
# ---------------------------------------------------------------
#
# configs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2

tar -jxvf eur_w_ld_chr.tar.bz2
bunzip2 w_hm3.snplist.bz2 


# ---------------------------------------------------------------
#
# 1. prep data
#

bash $DIR/prepData.sh



# ---------------------------------------------------------------
#
# 2.  Genetic correlation
#


bash $DIR/ldregression.sh


# ---------------------------------------------------------------
#
# 3. heritability, LAEF, LAmin&max
#


bash $DIR/ldh2.sh
