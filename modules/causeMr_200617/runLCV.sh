#
# Run LCV
#
# -----------------------------------------------
#
# configs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load moab
mkdir -p sumstats

#git clone https://github.com/bulik/ldsc.git
#cd ldsc
#conda env create --file environment.yml

#git clone https://github.com/lukejoconnor/LCV.git
source activate ldsc
#wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
#bunzip2 w_hm3.snplist.bz2
#wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase3_baselineLD_v2.2_ldscores.tgz
#tar -xvzf 1000G_Phase3_baselineLD_v2.2_ldscores.tgz
tar -jxvf eur_w_ld_chr.tar.bz2

gzcat ${DIR}/ldscores/eur_w_ld_chr/*.l2.ldscore.gz > ${DIR}/ldscores/unannotated_LDscores.l2.ldsc


# -----------------------------------------------
#
# munge sumstats
#


for i in `find ${DIR}/data/*.gcta.tsv.gz` 
do

    out=${DIR}/sumstats/$(basename ${i%.gcta.tsv.gz})
    echo $out

    python ${DIR}/ldsc/munge_sumstats.py \
        --sumstats ${i} \
        --a1 A1 \
        --a2 A2 \
        --signed-sumstats b,0 \
        --out $out \
        --snp SNP \
        --p p \
        --N-col N \
        --merge-alleles w_hm3.snplist

done



# -----------------------------------------------
#
# run LCV
#


exposurearr=(AF HF AS AIS CES)
outcomearr=(lamin ilamin lamax ilamax latef laaef lapef)


for exposure in "${exposurearr[@]}"
do
    for outcome in "${outcomearr[@]}"; do
            cat > pbsscripts/lcv.${exposure}.${outcome}.pbs <<EOF

#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=16gb,walltime=14400
#PBS -N lcv.${exposure}_${outcome}
cd \$PBS_O_WORKDIR

Rscript lcvAnalysis.R $exposure $outcome

EOF

            echo "lcv.${exposure}.${outcome}"
            msub pbsscripts/lcv.${exposure}.${outcome}.pbs
            sleep 2
    done
done


