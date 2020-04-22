#
#
# Run flashPCA on all samples primary and replication
# created: 200420
#
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 
module load moab


data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb


# -----------------------------------------------------------
#
# merge plink files
#

fam=ukb43247_cal_chr1_v2_s488288.fam 
find $data/*bed | sort > $DIR/bedFiles; find $data/*bim | sort > $DIR/bimFiles
paste $DIR/bedFiles $DIR/bimFiles | \
    perl -ane 'chomp; print"$_\tukb43247_cal_chr1_v2_s488288.fam\n"' > allPlinkFiles.txt




# -----------------------------------------------------------
#
# PCA QC's
#

. pcaQC.sh


# -----------------------------------------------------------
#
# flashPCA
#

cat > flashPCA.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=10,mem=12gb:fatnode,walltime=42000
#PBS -N flashPCA
cd \$PBS_O_WORKDIR
module load plink2/1.90beta3

. flashPCA.sh

EOF

qsub flashPCA.pbs


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
