# 
#
# Run C+T bayes PRS
#
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab

# -----------------------------------------------------------
#
# qsub
#


msub -t 0-6 run_bayesRR.pbs

