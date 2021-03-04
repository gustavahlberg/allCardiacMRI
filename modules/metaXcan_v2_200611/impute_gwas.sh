#
# IO's
#
# ------------------------------------------------



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GWAS_TOOLS=${DIR}/summary-gwas-imputation/src
DATA=${DIR}/data
OUTPUT=${DIR}/output
METAXCAN=${DIR}/MetaXcan/software/


gwasHarm=${DIR}/output_af/harmonized_gwas/finngen_harmonized.txt.gz
gwasName=$(basename ${gwasHarm})



# -------------------------------------------------
#
# Imputation of summary statistics
#

chr=1
sb=0


for chr in {1..22} 
do
    echo "running chr $chr"
    for sb in {0..4}
    do
        echo "running subbatch $sb"

        gwasSubImp=${gwasName%.txt.gz}_chr${chr}_sb${sb}_reg0.1_ff0.01_by_region.txt.gz

        cat > pbsscripts/impute.${chr}.${sb}.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=16gb,walltime=10800
#PBS -N impute.${chr}.${sb}
cd \$PBS_O_WORKDIR
module load tools
conda activate imlabtools


        python $GWAS_TOOLS/gwas_summary_imputation.py \
            -by_region_file $DATA/eur_ld.bed.gz \
            -gwas_file ${gwasHarm} \
            -parquet_genotype $DATA/reference_panel_1000G/chr${chr}.variants.parquet \
            -parquet_genotype_metadata $DATA/reference_panel_1000G/variant_metadata.parquet \
            -window 100000 \
            -parsimony 7 \
            -chromosome ${chr} \
            -regularization 0.1 \
            -frequency_filter 0.01 \
            -sub_batches 5 \
            -sub_batch ${sb} \
            --standardise_dosages \
            -output $OUTPUT/summary_imputation/${gwasSubImp}

EOF
        qsub pbsscripts/impute.${chr}.${sb}.pbs
        sleep 1
    done
done 



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
