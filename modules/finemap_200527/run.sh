#
#
# Created 200520
# run.sh: run script for 
# running finemap analysis
# 
# Input:
# (1) Master file
# (2) Z file
# (3) LD file
# 
# 1. Make z files   
# 2. Make ld files
# 3. Make master files
# 4. run finemap
# 5. 
# 6. 
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR




# -----------------------------------------------------------
#
# 1. Make z files   
#

Rscript makeZfile.R


# -----------------------------------------------------------
#
# 2. Make ld files
#


for zfile in `find data/*z`;
do
    echo $zfile
    bash ${DIR}/makeLdMatrix.sh $zfile
done


# -----------------------------------------------------------
#
# 3. Make master files
#


echo "z;ld;snp;config;cred;log;n_samples" > masterFile.txt
n_samples=35648

for zfile in `find data/*z`;
do
    
    name=$(basename $zfile)
    outFn=output/$name
    ldfile=ldFiles/${name%.z}.ld
    snpfile=${outFn%.z}.snp
    config=${outFn%.z}.config
    cred=${outFn%.z}.cred
    log=${outFn%.z}.log
    
    echo "$zfile;$ldfile;$snpfile;$config;$cred;$log;$n_samples" >> masterFile.txt

done


# -----------------------------------------------------------
#
# 4. run finemap
#

module load  finemap/1.4 


finemap --sss --in-files masterFile.txt --log \
    --n-causal-snps 5 \
    --n-conv-sss 500  > finemap.log


#finemap --sss --in-files testFile.txt --log \
#    --n-causal-snps 5 \
#    --n-conv-sss 500 
