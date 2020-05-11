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


## ----------------------------------------------------
##
## add new pc's
##


#Rscript addPCAs.R

jobid=`msub -t 0-1 gwas_bolt.pbs`
checkjob -v $jobid


# ----------------------------------------------------
#
# run bolt
#

jobid=`msub -t 0-20 gwas_bolt.pbs`
checkjob -v $jobid


jobid=`msub -t 0-20 gwas_bolt_rtrn.pbs`
checkjob -v $jobid


# ----------------------------------------------------
#
# run bolt w/o PC's
#

jobid=`msub -t 0-20 gwas_bolt_nopc.pbs`
checkjob -v $jobid


jobid=`msub -t 0-20 gwas_bolt_rtrn_nopc.pbs`
checkjob -v $jobid



#################################################
