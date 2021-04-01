# -----------------------------------------------------------
#
# check res
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


arr=(`find ${DIR}/data/send2Lit/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " "`)




# -----------------------------------------------------------
#
# list sample.id key
#

echo \"sample.id\" \"mri.id\" > ${DIR}/sample_key.txt


for sample in ${arr[@]}
do
    echo sample $sample
    mri_id=`head -2 ${DIR}/data/send2Lit/${sample}/manifest.csv | tail -1 | cut -f 2 -d ","`
    
    echo \"$sample\" \"$mri_id\" >> ${DIR}/sample_key.txt 

done




# -----------------------------------------------------------
#
# match to predicted measurements
#



Rscript "match2predMri.R"
