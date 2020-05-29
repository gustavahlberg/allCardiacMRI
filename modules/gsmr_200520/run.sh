#
#
# Created 200520
# run.sh: run script for 
# running gsmr/cojo analysis
# 
# 1. select a subset of 12,000 controls
# 2. subset genotypes to snps in summary stats and the 12,000 sample set
# 3. reformat files for cojo
# 4. run gsmr
# 5. run mtcojo
# 6. run cojo (see cojo module)
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


# -----------------------------------------------------------
#
# 1. select a subset of 12,000 controls
#

Rscript selectControlGroup.R


# -----------------------------------------------------------
#
# 3. reformat files for cojo
#

. reFormatSumstats.sh



# -----------------------------------------------------------
#
# 4. run gsmr
#

. runGsmr.sh


# -----------------------------------------------------------
#
# 5. run mtcojo
#

. runMtcojo.sh



# -----------------------------------------------------------
#
# 6.  get res. from mtcojo in sign loci
#

. getMtCojoRes.sh




###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # 
###########################################


