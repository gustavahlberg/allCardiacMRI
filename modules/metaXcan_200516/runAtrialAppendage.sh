#!/bin/bash
#
# MetaXcan w/ atrial appendage
#
# --------------------------------------------------------
#
# heart atrial appendage
#


for sumstat in `find ${gwasFolder}`
do
    sumstat="$(basename $sumstat)"
    res=${sumstat%.bgen.stats.gz}_la.txt
    out=${DIR}/results/$res
           
    ${DIR}/MetaXcan/software/MetaXcan.py \
          --model_db_path ${modelDB_AA} \
          --covariance ${covariance_AA} \
          --gwas_folder ${gwasFolder} \
          --gwas_file_pattern $sumstat \
          --snp_column SNP \
          --effect_allele_column ALLELE1 \
          --non_effect_allele_column ALLELE0 \
          --beta_column BETA \
          --pvalue_column P_BOLT_LMM \
          --additional_output \
          --output_file ${out}
done



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
