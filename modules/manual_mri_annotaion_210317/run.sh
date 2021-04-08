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


cd data
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
qsub download_outlier2.pbs


# -----------------------------------------------------------
#
# sort
#



arr=(`find ${DIR}/included/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " "`)
 

for sample in ${arr[@]:0:40}
do
    echo copy sample $sample
    
    mkdir -p ${DIR}/send2Lit/${sample}
    cp ${DIR}/included/${sample}/dicom/manifest* ${DIR}/send2Lit/${sample}/.
    cp -r ${DIR}/included/${sample}/dicom/CINE_segmented_LAX_2Ch ${DIR}/send2Lit/${sample}/.
    cp -r ${DIR}/included/${sample}/dicom/CINE_segmented_LAX_4Ch ${DIR}/send2Lit/${sample}/.

    lt ${DIR}/send2Lit/${sample}
done

#outliers
arr=(`find ${DIR}/outlier/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " "`)


for sample in ${arr[@]:0:40}
do
    echo copy sample $sample
    
    mkdir -p ${DIR}/send2Lit/${sample}
    cp ${DIR}/outlier/${sample}/dicom/manifest* ${DIR}/send2Lit/${sample}/.
    cp -r ${DIR}/outlier/${sample}/dicom/CINE_segmented_LAX_2Ch ${DIR}/send2Lit/${sample}/.
    cp -r ${DIR}/outlier/${sample}/dicom/CINE_segmented_LAX_4Ch ${DIR}/send2Lit/${sample}/.

    lt ${DIR}/send2Lit/${sample}
done


#outliers2
arr=(`find ${DIR}/outlier2/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " "`)
for sample in ${arr[@]:0:50}
do
    echo copy sample $sample
    
    mkdir -p ${DIR}/send2Lit_2/${sample}
    cp ${DIR}/outlier2/${sample}/dicom/manifest* ${DIR}/send2Lit_2/${sample}/.
    cp -r ${DIR}/outlier2/${sample}/dicom/CINE_segmented_LAX_2Ch ${DIR}/send2Lit_2/${sample}/.
    cp -r ${DIR}/outlier2/${sample}/dicom/CINE_segmented_LAX_4Ch ${DIR}/send2Lit_2/${sample}/.

    lt ${DIR}/send2Lit_2/${sample}
done


#included 2
arr=(`find ${DIR}/included/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " "`)

for sample in ${arr[@]:0:50}
do
    echo copy sample $sample
    
    mkdir -p ${DIR}/send2Lit_2/${sample}
    cp ${DIR}/included/${sample}/dicom/manifest* ${DIR}/send2Lit_2/${sample}/.
    cp -r ${DIR}/included/${sample}/dicom/CINE_segmented_LAX_2Ch ${DIR}/send2Lit_2/${sample}/.
    cp -r ${DIR}/included/${sample}/dicom/CINE_segmented_LAX_4Ch ${DIR}/send2Lit_2/${sample}/.

    lt ${DIR}/send2Lit_2/${sample}
done



# -----------------------------------------------------------
#
# rm already annotated
#

Rscript rmAlreadyAnnotated.R


# -----------------------------------------------------------
#
# check res
#


bash ${DIR}/checkRes.sh




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
