#
# 
#  1) Harmonization of GWAS variants
# Fixing GWAS format inconsistencies
# Mapping genomic coordinates between different human genome release assemblies.
# curating variants for matching allele definition
# 2) Imputation of summary statistics
# Using a reference panel to impute missing associations from present ones using BLUP (Best Linear Unbiased predictors) Performed on harmonized GWAS
# 3) Integration with MASHR-M models
# 
# -------------------------------------------------
#
# configs
#

source activate imlabtools
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GWAS_TOOLS=${DIR}/summary-gwas-imputation/src
GWASDIR=${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn
DATA=${DIR}/data
OUTPUT=${DIR}/output
METAXCAN=${DIR}/MetaXcan/software/


# -------------------------------------------------
#
# a) format Betas to SD units
#

Rscript formatBetas2SD.R
gzip -f ${DIR}/../gwas_w_bolt_v2_200420/results/gwas_rtrn/*betastd.tsv &


# -------------------------------------------------
#
# b) run MetaXcan
#

gwasFiles=(rntrn_ilamax.bgen.stats.betastd.tsv.gz rntrn_ilamin.bgen.stats.betastd.tsv.gz rntrn_laaef.bgen.stats.betastd.tsv.gz rntrn_lamax.bgen.stats.betastd.tsv.gz rntrn_lamin.bgen.stats.betastd.tsv.gz rntrn_lapef.bgen.stats.betastd.tsv.gz rntrn_latef.bgen.stats.betastd.tsv.gz)

# -------------------------------------------------
#
# 1 & 2) Harmonization of GWAS variants & Imputation of summary statistics
#


for gwas in ${gwasFiles[@]}
do
    echo $gwas
    bash ${DIR}/runImputaionGwas.sh $gwas

done



# -------------------------------------------------
#
# 3) Post process imputation
#


# gwasFiles=(rntrn_ilamax.bgen.stats.betastd.tsv.gz rntrn_ilamin.bgen.stats.betastd.tsv.gz rntrn_laaef.bgen.stats.betastd.tsv.gz rntrn_lamax.bgen.stats.betastd.tsv.gz rntrn_lamin.bgen.stats.betastd.tsv.gz rntrn_lapef.bgen.stats.betastd.tsv.gz rntrn_latef.bgen.stats.betastd.tsv.gz)


# for gwas in ${gwasFiles[@]}
# do
#     echo $gwas
#     gwasHarm=${gwas%.bgen.stats.gz}.txt.gz
#     gwasName=${gwas%.tsv.gz}

#     python $GWAS_TOOLS/gwas_summary_imputation_postprocess.py \
#         -gwas_file $OUTPUT/harmonized_gwas/${gwasHarm} \
#         -folder $OUTPUT/summary_imputation \
#         -pattern ${gwasName}* \
#         -parsimony 7 \
#         -output $OUTPUT/processed_summary_imputation/imputed_${gwasHarm}

# done




# -------------------------------------------------
#
# 4) Run MetaXcan 
#

module load moab
gwasFiles=(rntrn_ilamax.bgen.stats.betastd.tsv.gz rntrn_ilamin.bgen.stats.betastd.tsv.gz rntrn_laaef.bgen.stats.betastd.tsv.gz rntrn_lamax.bgen.stats.betastd.tsv.gz rntrn_lamin.bgen.stats.betastd.tsv.gz rntrn_lapef.bgen.stats.betastd.tsv.gz rntrn_latef.bgen.stats.betastd.tsv.gz)


for gwas in ${gwasFiles[@]}
do
    echo $gwas
         cat > pbsscripts/metaxcan.${gwas}.pbs <<EOF

#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=16gb,walltime=10800
#PBS -N $gwas
cd \$PBS_O_WORKDIR

    bash ./runMetaXcan.sh $gwas
EOF
msub pbsscripts/metaxcan.${gwas}.pbs
sleep 1
done





# python $METAXCAN/SMulTiXcan.py \
#     --models_folder $DATA/models/eqtl/mashr \
#     --models_name_pattern "mashr_(Heart.*).db" \
#     --snp_covariance $DATA/models/gtex_v8_expression_mashr_snp_covariance.txt.gz \
#     --metaxcan_folder $OUTPUT/spredixcan/eqtl/ \
#     --metaxcan_filter "${gwasName}_(.*).csv" \
#     --metaxcan_file_name_parse_pattern "(.*)_(.*).csv" \
#     --gwas_file $OUTPUT/processed_summary_imputation/imputed_${gwasHarm} \
#     --snp_column panel_variant_id \
#     --effect_allele_column effect_allele \
#     --non_effect_allele_column non_effect_allele \
#     --zscore_column zscore \
#     --keep_non_rsid \
#     --model_db_snp_key varID \
#     --cutoff_condition_number 30 \
#     --verbosity 7 \
#     --throw \
#     --output $OUTPUT/smultixcan/eqtl/${gwasName}_smultixcan.txt


# -------------------------------------------------
#
# 5) test coloc
#

gwas=rntrn_lapef.bgen.stats.betastd.tsv.gz
gwasHarm=${gwas%.bgen.stats.gz}.txt.gz
gwasName=${gwasHarm%.txt.gz}


python3 $GWAS_TOOLS/run_coloc.py \
    -gwas_mode bse \
    -gwas $OUTPUT/processed_summary_imputation/imputed_${gwasHarm} \
    -eqtl_mode bse \
    -eqtl $DATA/GTEx_Analysis_v8_eQTL/Heart_Atrial_Appendage.v8.signif_variant_gene_pairs.txt.gz \
    -gwas_sample_size FROM_GWAS \
    -eqtl_sample_size 372 \
    -p1 2.4769e-05 \
    -p2 0.00288782 \
    -p12 1.264e-06 \
    -parsimony 8 \
    -output test 
