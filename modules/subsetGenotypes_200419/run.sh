#
#
# Created 200419
# run.sh: run script for 
# subsetting all genotyping set
#
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load plink2/1.90beta5.4


data=/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474


# -----------------------------------------------------------
#
# 2. subset bgen files
#


msub -t 0-22 subsetBgen.pbs


# -----------------------------------------------------------
#
# 2. convert to 8-bit bgen files
#


msub -t 1-22 subsetBgen_2.pbs





# -----------------------------------------------------------
#
# 5. check order of bgen file
#
# a) 

Rscript samplecheckLists.R

# b) check
sanityCheckOrder.sh
Rscript samplecheckLists.R

#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################


