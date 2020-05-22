#
# 5. run mtcojo
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

wget https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2
tar -jxvf eur_w_ld_chr.tar.bz2

module load gcta/1.92.4beta 
find subsetGenotypes/cojo_*fam | sed s/.fam// > gsmr_ref_data.txt
refData=gsmr_ref_data.txt
summaryDataList=mtcojo_summary_data.list


lafiles=(lamin.gcta.tsv.gz lamax.gcta.tsv.gz ilamin.gcta.tsv.gz ilamax.gcta.tsv.gz laaef.gcta.tsv.gz lapef.gcta.tsv.gz latef.gcta.tsv.gz)
laphenos=(lamin lamax ilamin ilamax laaef lapef latef)

# -----------------------------------------------------------
#
#  mtcojo condition on AF
#


for i in ${!laphenos[@]}
do
    
    echo ${laphenos[$i]} data/${lafiles[$i]} > ${summaryDataList}_${laphenos[$i]} 
    echo "AF data/AF_sumstat.gcta.tsv.gz" >> ${summaryDataList}_${laphenos[$i]} 
    out=${DIR}/mtCojoResults/${laphenos[$i]}_condAF.mtcojoRes

    echo $i
cat > mtcojoAF.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=10gb:fatnode,walltime=36000
#PBS -N mtcojoAF
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
    gcta64 --mbfile $refData \
        --mtcojo-file ${summaryDataList}_${laphenos[$i]}  \
        --ref-ld-chr eur_w_ld_chr/ \
        --w-ld-chr eur_w_ld_chr/ \
        --out $out
EOF
qsub mtcojoAF.pbs
sleep 1

done

# -----------------------------------------------------------
#
#  mtcojo condition on HF
#


for i in ${!laphenos[@]}
do
    
    echo ${laphenos[$i]} data/${lafiles[$i]} > ${summaryDataList}_${laphenos[$i]}_HF
    echo "HF data/HF_sumstat.gcta.tsv.gz" >> ${summaryDataList}_${laphenos[$i]}_HF
    out=${DIR}/mtCojoResults/${laphenos[$i]}_condHF.mtcojoRes

    echo $i
cat > mtcojoHF.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=10gb:fatnode,walltime=36000
#PBS -N mtcojoHF
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
    gcta64 --mbfile $refData \
        --mtcojo-file ${summaryDataList}_${laphenos[$i]}_HF  \
        --ref-ld-chr eur_w_ld_chr/ \
        --w-ld-chr eur_w_ld_chr/ \
        --out $out
EOF
qsub mtcojoHF.pbs
sleep 2

done



# -----------------------------------------------------------
#
#  rntrn setting
#

lafiles=(rntrn_lamin.gcta.tsv.gz rntrn_lamax.gcta.tsv.gz rntrn_ilamin.gcta.tsv.gz rntrn_ilamax.gcta.tsv.gz rntrn_laaef.gcta.tsv.gz rntrn_lapef.gcta.tsv.gz rntrn_latef.gcta.tsv.gz)
laphenos=(rntrn_lamin rntrn_lamax rntrn_ilamin rntrn_ilamax rntrn_laaef rntrn_lapef rntrn_latef)



# -----------------------------------------------------------
#
#  rntrn mtcojo condition on AF
#


for i in ${!laphenos[@]}
do
    
    echo ${laphenos[$i]} data/${lafiles[$i]} > ${summaryDataList}_${laphenos[$i]} 
    echo "AF data/AF_sumstat.gcta.tsv.gz" >> ${summaryDataList}_${laphenos[$i]} 
    out=${DIR}/mtCojoResults/${laphenos[$i]}_condAF.mtcojoRes

    echo $i
cat > mtcojoAF.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=10gb:fatnode,walltime=36000
#PBS -N mtcojoAF_rntrn
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
    gcta64 --mbfile $refData \
        --mtcojo-file ${summaryDataList}_${laphenos[$i]}  \
        --ref-ld-chr eur_w_ld_chr/ \
        --w-ld-chr eur_w_ld_chr/ \
        --out $out
EOF
qsub mtcojoAF.pbs
sleep 1

done

# -----------------------------------------------------------
#
#  rntrn mtcojo condition on HF
#

for i in ${!laphenos[@]}
do
    
    echo ${laphenos[$i]} data/${lafiles[$i]} > ${summaryDataList}_${laphenos[$i]}_HF
    echo "HF data/HF_sumstat.gcta.tsv.gz" >> ${summaryDataList}_${laphenos[$i]}_HF
    out=${DIR}/mtCojoResults/${laphenos[$i]}_condHF.mtcojoRes

    echo $i
cat > mtcojoHF.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=10gb:fatnode,walltime=36000
#PBS -N mtcojoHF_rntrn
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
    gcta64 --mbfile $refData \
        --mtcojo-file ${summaryDataList}_${laphenos[$i]}_HF  \
        --ref-ld-chr eur_w_ld_chr/ \
        --w-ld-chr eur_w_ld_chr/ \
        --out $out
EOF
qsub mtcojoHF.pbs
sleep 1

done




# -----------------------------------------------------------
#
#  mtcojo condition on DBP
#


