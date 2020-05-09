# -----------------------------------------------------------
#
# run King robust
#
# -----------------------------------------------------------
#
# IO's
#

module load intel/perflibs/64 
module load R/3.6.1
module load king/2.1.3
bed=intermediate/ukbMriSubset.maf.reg1.reg.bed
fam=intermediate/ukbMriSubset.maf.reg1.reg.fam
bim=intermediate/ukbMriSubset.maf.reg1.reg.bim

# -----------------------------------------------------------
#
# run King and partition w/ pc-air
#

# Rscript KingRobust.R

cat <<EOF > Kingrobust.pbs
#!/bin/bash 
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n
#PBS -l nodes=1:ppn=14,mem=64gb,walltime=180000
#PBS -N 
#PBS -o \$PBS_JOBNAME.\$PBS_JOBID.out
#PBS -o \$PBS_JOBNAME.\$PBS_JOBID.err
cd \$PBS_O_WORKDIR

module load intel/perflibs/64 
module load R/3.6.1

Rscript KingRobust.R

EOF

msub Kingrobust.pbs




# -----------------------------------------------------------
#
# Rm intermediate
#

lt $DIR/intermediate
rm $DIR/intermediate/*

#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
