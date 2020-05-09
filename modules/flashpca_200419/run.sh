#
#
# Run flashPCA
# created: 200224
#
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 
module load moab
module load flashpca/2.0


data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb


# -----------------------------------------------------------
#
# merge plink files
#

# fam=ukb43247_cal_chr1_v2_s488288.fam 
# find $data/*bed | sort > $DIR/bedFiles; find $data/*bim | sort > $DIR/bimFiles
# paste $DIR/bedFiles $DIR/bimFiles | \
#     perl -ane 'chomp; print"$_\tukb43247_cal_chr1_v2_s488288.fam\n"' > allPlinkFiles.txt

# cat > mergePlink.pbs <<EOF
# #!/bin/bash
# #PBS group_list=cu_10039 -A cu_10039
# #PBS -m n 
# #PBS -l nodes=1:ppn=2,mem=240gb:fatnode,walltime=24000
# #PBS -N merge
# cd \$PBS_O_WORKDIR
# module load plink2/1.90beta3

# plink --merge-list allPlinkFiles.txt \
#     --make-bed \
#     --out $ukb \

# EOF

# qsub mergePlink.pbs



# -----------------------------------------------------------
#
# King QC's
#

bash kingQC.sh


# -----------------------------------------------------------
#
# KING robust
#

bash kingRobust.sh


# -----------------------------------------------------------
#
# PCA QC's
#

bash pcaQC.sh


# -----------------------------------------------------------
#
# flashPCA
#

cat > flashPCA.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=10,mem=12gb:fatnode,walltime=48000
#PBS -N flashPCA
cd \$PBS_O_WORKDIR
module load plink2/1.90beta3

. flashPCA.sh

EOF

qsub flashPCA.pbs



# -----------------------------------------------------------
#
# project PCA's
#


in=genPCA/ukbMriSubset.rel.ld
outProj=$DIR/results/ukbMriSubset.relate.FlashProj.txt

flashpca --bfile $in \
    --project \
    --inmeansd meansd.txt \
    --outproj $outProj \
    --inload loadings.txt \
    -v


# -----------------------------------------------------------
#
# merge pca and projected
#

cd $DIR/results/
head -1 ukbMriSubset.unrel.FlashPca.txt > header
cat ukbMriSubset.unrel.FlashPca.txt ukbMriSubset.relate.FlashProj.txt | \
    grep -v FID | cat header - > ukbMriSubset.FlashPca.all.txt


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
