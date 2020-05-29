#
#
# Created 200526
# run.sh: run script for 
# running cojo analysis
# 
# 1-2 see module ../gsmr_200520/ 
# 1. use the 12,000 controls as a refernce
# 2. Use previously reformated summarystats for gcta 
# 3. Merge plink files
# 4. run cojo analysis on cluster
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
module load gcta/1.91.0beta 


# -----------------------------------------------------------
#
# 4. merge plink files
#



# cat > mergePlink.pbs <<EOF
# #!/bin/bash
# #PBS group_list=cu_10039 -A cu_10039
# #PBS -m n 
# #PBS -l nodes=1:ppn=2,mem=16gb:walltime=24000
# #PBS -N merge
# cd \$PBS_O_WORKDIR
# module load plink2/1.90beta3
# for i in {1..22}
# do
#     plink --bfile ../gsmr_200520/subsetGenotypes/cojo_${i} \
#         --make-bed \
#         --out tmp/cojo_${i} \
#         --exclude cojo-merge.missnp \
#         --indiv-sort 0
# done

# data=tmp
# find $data/*bed | sort > $DIR/bedFiles; find $data/*bim | sort > $DIR/bimFiles
# find $data/*fam | sort > $DIR/famFiles
# paste $DIR/bedFiles $DIR/bimFiles $DIR/famFiles > allPlinkFiles.txt
# rm $DIR/bedFiles $DIR/bimFiles $DIR/famFiles


# plink --merge-list allPlinkFiles.txt \
#     --make-bed \
#     --out cojo \
#     --indiv-sort 0

# rm tmp/*
# EOF

# qsub mergePlink.pbs




# -----------------------------------------------------------
#
# 4. run cojo analysis on cluster
#


msub -t 0-6 gctaCojo_200526.pbs


# -----------------------------------------------------------
#
# 5. run cojo on sentinels
#


msub -t 0-6 gctaCojoSentinels_200526.pbs



################################################
# EOF # EOF# EOF# EOF# EOF# EOF# EOF# EOF# EOF #
################################################
