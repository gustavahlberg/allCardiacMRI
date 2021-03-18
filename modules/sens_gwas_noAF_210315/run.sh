#
#
#  run script for gwas w/bolt
#
# ----------------------------------------------------
#
# config
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4
module load bolt-lmm/2.3.4 


# ----------------------------------------------------
#
# exclude AF
#


Rscript excludeAF.R


# ----------------------------------------------------
#
# run bolt
#


gwas_bolt_rtrn_noaf.pbs



#################################################
