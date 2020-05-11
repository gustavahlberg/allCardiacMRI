#
#
#  run bolt h2 and genetic correlation
#
# ----------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab
module load bgen/20180807
module load lapack/3.6.0
module load qctool/2.0.1
module load snptest/2.5.2
module load plink2/1.90beta5.4
module load bolt-lmm/2.3.4 
pth=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497

# ---------------------------------------------------------
#
# phenoarray
#

phenoarray=(lamax lamin latef lapef laaef ilamax ilamin LVEF LVEDV LVESV)


# ---------------------------------------------------------
#
# qsub
#


for i in `seq 0 $((${#phenoarray[@]} - 2))`
do
    k=$(($i + 1 ))
    for j in `seq $k $((${#phenoarray[@]} - 1))`
    do
        pheno1=${phenoarray[$i]}
        pheno2=${phenoarray[$j]}
        echo "Welcome ${i}-${j} times"
        echo "Welcome ${pheno1}-${pheno2} times"

        cat <<EOF > h2_bolt_${pheno1}_${pheno2}.pbs
#!/bin/bash 
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n
#PBS -l nodes=1:ppn=10,mem=12gb,walltime=36000
#PBS -N 
#PBS -o h2_bolt_${pheno1}_${pheno2}.out
#PBS -o h2_bolt_${pheno1}_${pheno2}.err
cd \$PBS_O_WORKDIR

bash ${DIR}/boltReml_h2_gencor.sh ${pheno1} ${pheno2} ${pheno1}_${pheno2}

EOF

        msub h2_bolt_${pheno1}_${pheno2}.pbs
        sleep 1
    done
    
done






