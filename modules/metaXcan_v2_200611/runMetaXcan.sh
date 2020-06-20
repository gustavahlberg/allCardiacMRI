#
# Run MetaXcan
#
# ------------------------------------------------

source activate imlabtools
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GWAS_TOOLS=${DIR}/summary-gwas-imputation/src
GWASDIR=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn
DATA=${DIR}/data
OUTPUT=${DIR}/output
METAXCAN=${DIR}/MetaXcan/software/


gwas=$1
#gwas=rntrn_ilamax.bgen.stats.betastd.tsv.gz
gwasHarm=${gwas%.bgen.stats.gz}.txt.gz
gwasName=${gwasHarm%.txt.gz}


# -------------------------------------------------
#
# 3) 
#


python $METAXCAN/SPrediXcan.py \
    --gwas_file $OUTPUT/harmonized_gwas/${gwasHarm} \
    --snp_column panel_variant_id \
    --effect_allele_column effect_allele \
    --non_effect_allele_column non_effect_allele \
    --zscore_column zscore \
    --pvalue_column pvalue \
    --beta_column effect_size \
    --se_column standard_error \
    --model_db_path $DATA/models/eqtl/mashr/mashr_Heart_Atrial_Appendage.db \
    --covariance $DATA/models/eqtl/mashr/mashr_Heart_Atrial_Appendage.txt.gz \
    --keep_non_rsid \
    --additional_output \
    --model_db_snp_key varID \
    --throw \
    --output_file $OUTPUT/spredixcan/eqtl/${gwasName}_PM_Heart_Atrial_Appendage.csv

python $METAXCAN/SPrediXcan.py \
    --gwas_file $OUTPUT/harmonized_gwas/${gwasHarm} \
    --snp_column panel_variant_id \
    --effect_allele_column effect_allele \
    --non_effect_allele_column non_effect_allele \
    --zscore_column zscore \
    --pvalue_column pvalue \
    --beta_column effect_size \
    --se_column standard_error \
    --model_db_path $DATA/models/eqtl/mashr/mashr_Heart_Left_Ventricle.db \
    --covariance $DATA/models/eqtl/mashr/mashr_Heart_Left_Ventricle.txt.gz \
    --keep_non_rsid \
    --additional_output \
    --model_db_snp_key varID \
    --throw \
    --output_file $OUTPUT/spredixcan/eqtl/${gwasName}_PM_Heart_Left_Ventricle.csv



python $METAXCAN/SMulTiXcan.py \
    --models_folder $DATA/models/eqtl/mashr \
    --models_name_pattern "mashr_(.*).db" \
    --snp_covariance $DATA/models/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
    --metaxcan_folder $OUTPUT/spredixcan/eqtl/ \
    --metaxcan_filter "${gwasName}_PM_(.*).csv" \
    --metaxcan_file_name_parse_pattern "(.*)_PM_(.*).csv" \
    --gwas_file $OUTPUT/harmonized_gwas/${gwasHarm} \
    --snp_column panel_variant_id \
    --effect_allele_column effect_allele \
    --non_effect_allele_column non_effect_allele \
    --zscore_column zscore \
    --keep_non_rsid \
    --model_db_snp_key varID \
    --cutoff_condition_number 30 \
    --verbosity 7 \
    --throw \
    --output $OUTPUT/smultixcan/eqtl/${gwasName}_smultixcan.txt







#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
