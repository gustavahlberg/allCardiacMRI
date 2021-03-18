#
#
# Created 191107
# run.sh: run script for 
# automated analysis of CMR
#
# 1. test
# 2. qsub all 
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR



# -----------------------------------------------------------
#
# random subset  n=100
#

Rscript("selectRandomSubset.R")



# -----------------------------------------------------------
#
# 1 test
#

python download_data_ukbb_general.py \
    --data_root ../../data/test \
    --util_dir /home/projects/cu_10039/projects/ManageUkbb/bin/ \
    --ukbkey /home/projects/cu_10039/projects/cardiacMRI/.ukbkey \
    --csv_file ../../data/test/test.bulk



# -----------------------------------------------------------
#
# 2. qsub 
#

qsub download_included.pbs
qsub download_outlier.pbs
