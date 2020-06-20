#
# Run imputation of gwas
#
# ------------------------------------------------


module load moab
source activate imlabtools
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GWAS_TOOLS=${DIR}/summary-gwas-imputation/src
GWASDIR=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn
DATA=${DIR}/data
OUTPUT=${DIR}/output
METAXCAN=${DIR}/MetaXcan/software/


gwas=$1
#gwas=rntrn_lamax.bgen.stats.betastd.tsv.gz 
gwasHarm=${gwas%.bgen.stats.gz}.txt.gz
gwasName=${gwasHarm%.txt.gz}



# -------------------------------------------------
#
# 1) Harmonization of GWAS variants
#

 
python $GWAS_TOOLS/gwas_parsing.py \
    -gwas_file $GWASDIR/$gwas \
    -liftover $DATA/liftover/hg19ToHg38.over.chain.gz \
    -snp_reference_metadata $DATA/reference_panel_1000G/variant_metadata.txt.gz METADATA \
    -output_column_map SNP variant_id \
    -output_column_map ALLELE0 non_effect_allele \
    -output_column_map ALLELE1 effect_allele \
    -output_column_map bstd effect_size \
    -output_column_map P_BOLT_LMM pvalue \
    -output_column_map CHR chromosome \
    -output_column_map CHISQ_BOLT_LMM zscore \
    -output_column_map sestd standard_error \
    -output_column_map BP position \
    -output_column_map A1FREQ frequency \
    --chromosome_format \
    --insert_value sample_size 35648 \
    --insert_value n_cases 35648 \
    -output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele frequency pvalue zscore effect_size standard_error sample_size n_cases\
    -output $OUTPUT/harmonized_gwas/${gwasHarm}



# -------------------------------------------------
#
# 2) Imputation of summary statistics
#

#chr=1
#sb=0


# for chr in {1..22} 
# do
#     echo "running chr $chr"
#     for sb in {0..4}
#     do
#         echo "running subbatch $sb"

#         gwasSubImp=${gwasHarm%.txt.gz}_chr${chr}_sb${sb}_reg0.1_ff0.01_by_region.txt.gz

#         cat > pbsscripts/impute.${chr}.${sb}.pbs <<EOF
# #!/bin/bash
# #PBS group_list=cu_10039 -A cu_10039
# #PBS -m n 
# #PBS -l nodes=1:ppn=2,mem=16gb,walltime=10800
# #PBS -N impute.${chr}.${sb}
# cd \$PBS_O_WORKDIR
# source activate imlabtools

#         python $GWAS_TOOLS/gwas_summary_imputation.py \
#             -by_region_file $DATA/eur_ld.bed.gz \
#             -gwas_file $OUTPUT/harmonized_gwas/${gwasHarm} \
#             -parquet_genotype $DATA/reference_panel_1000G/chr${chr}.variants.parquet \
#             -parquet_genotype_metadata $DATA/reference_panel_1000G/variant_metadata.parquet \
#             -window 100000 \
#             -parsimony 7 \
#             -chromosome ${chr} \
#             -regularization 0.1 \
#             -frequency_filter 0.01 \
#             -sub_batches 5 \
#             -sub_batch ${sb} \
#             --standardise_dosages \
#             -output $OUTPUT/summary_imputation/${gwasSubImp}

# EOF
#         msub pbsscripts/impute.${chr}.${sb}.pbs
#         sleep 1
#     done
# done 



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
