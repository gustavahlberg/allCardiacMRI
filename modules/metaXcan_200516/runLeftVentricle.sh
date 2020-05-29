#!/bin/bash
#
# MetaXcan w/ left ventricle
#
# --------------------------------------------------------
#
# heart left ventricle
#


for sumstat in `find ${gwasFolder}`
do
    sumstat="$(basename $sumstat)"
    res=${sumstat%.bgen.stats.gz}_lv.txt
    out=${DIR}/results/$res
           
    ${DIR}/MetaXcan/software/MetaXcan.py \
          --model_db_path ${modelDB_LV} \
          --covariance ${covariance_LV} \
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
