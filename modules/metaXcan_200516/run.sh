#!/bin/bash
#
# MetaXcan
#
# -----------------------------------------------
#
#  configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA=${HOME}/RESOURCES/pheweb
PATH=$PATH:${HOME}/src/ldsc 


source activate py27
python --version

#install
#git clone https://github.com/hakyimlab/MetaXcan

# --------------------------------------------------------
#
# I/O's
#

gwasFolder=${DIR}/../../data/gwas_results/gwas_regular


modelDB_AA=${DIR}/data/Heart_Atrial_Appendage/gtex_v7_Heart_Atrial_Appendage_imputed_europeans_tw_0.5_signif.db
covariance_AA=${DIR}/data/Heart_Atrial_Appendage/gtex_v7_Heart_Atrial_Appendage_imputed_eur_covariances.txt.gz

modelDB_LV=${DIR}/data/Heart_Left_Ventricle/gtex_v7_Heart_Left_Ventricle_imputed_europeans_tw_0.5_signif.db
covariance_LV=${DIR}/data/Heart_Left_Ventricle/gtex_v7_Heart_Left_Ventricle_imputed_eur_covariances.txt.gz


# --------------------------------------------------------
#
# atrial appendage
#


bash runAtrialAppendage.sh



# --------------------------------------------------------
#
# left ventricle
#


bash runLeftVentricle.sh 


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################

