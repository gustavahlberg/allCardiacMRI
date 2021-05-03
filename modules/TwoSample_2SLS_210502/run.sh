#
#
# Created 200526
# run.sh: run script for 
# running cojo analysis
# 
# 1. map snps
# 2. pull out sentinel snps
# 3. Calculate two samples 2SLS
#
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

module load bgen/20180807
module load lapack/3.6.0
module unload R/4.0.0
module unload gcc/9.3.0
module load gcc/5.4.0  
module load qctool/2.0.1

ukbPath='/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/'
sampleData='/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample'



# -----------------------------------------------------------
#
# map snps
#



Rscript mapSnps.R



# ------------------------------------
#
# extract snps 
#




arr=(`find data/SnpsUKB*.txt | tr "\n" " "`)

for rs in ${arr[@]}; do

    echo $rs
    chr=`echo ${rs} | sed 's/data\/SnpsUKB//' | sed s/.txt//`
    file=${ukbPath}/ukb_imp_chr${chr}_v3.bgen
    out=data/sentinel_chr${chr}.dosage
    
    bgenix -g ${file} -incl-rsids ${rs} | \
	qctool -g - -filetype bgen \
	       -s $sampleData \
	       -og $out \
	       -ofiletype bimbam_dosage
done

# merge
cat ${DIR}/data/sentinel_chr*.dosage > ${DIR}/data/sentinel_all.dosage

#transpose
python -c "import sys; print('\n'.join(' '.join(c) for c in zip(*(l.split() for l in sys.stdin.readlines() if l.strip()))))" < ${DIR}/data/sentinel_all.dosage > ${DIR}/data/sentinel_all_trans.dosage



# ------------------------------------
#
# 3. Calculate two samples 2SLS
#



Rscript Main.R




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
