#
#
# Harmonization of GWAS variants
#
# -------------------------------------------------
#
# a) format Betas to SD units
#

Rscript formatBetas2SD.R

# -------------------------------------------------
#
# 1) Harmonization of GWAS variants
#


gwas=rntrn_latef.bgen.stats.gz 
gwasHarm=${gwas%.bgen.stats.gz}.txt.gz

python $GWAS_TOOLS/gwas_parsing.py \
    -gwas_file $GWASDIR/$gwas \
    -liftover $DATA/liftover/hg19ToHg38.over.chain.gz \
    -snp_reference_metadata $DATA/reference_panel_1000G/variant_metadata.txt.gz METADATA \
    -output_column_map SNP variant_id \
    -output_column_map ALLELE0 non_effect_allele \
    -output_column_map ALLELE1 effect_allele \
    -output_column_map BETA effect_size \
    -output_column_map P_BOLT_LMM pvalue \
    -output_column_map CHR chromosome \
    -output_column_map CHISQ_BOLT_LMM zscore \
    -output_column_map SE standard_error \
    -output_column_map BP position \
    -output_column_map A1FREQ frequency \
    --chromosome_format \
    --insert_value sample_size 35648 \
    -output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele frequency pvalue zscore effect_size standard_error sample_size n_cases \
    -output $OUTPUT/harmonized_gwas/${gwasHarm}


