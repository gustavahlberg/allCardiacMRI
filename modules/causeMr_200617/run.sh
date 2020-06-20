#
# Run CAUSE MR 200617
#
# -----------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
mkdir -p pbsscripts 
mkdir -p prunedSnps
module load intel/perflibs/64 R/3.6.1
module load moab
#Rscript installCause.R


# -----------------------------------------------
#
# LD prune 4 causal
#

# Rscript downloadLDdata.R


# -----------------------------------------------
#
# Reformat sumstats
#


Rscript reFormatSumstats.R  
gzip ${DIR}/data/*gcta.tsv

# -----------------------------------------------
#
# LD prune 4 causal
#

exposurearr=(lamin ilamin lamax ilamax latef laaef lapef)
outcomearr=(AF HF AS AIS CES)


for exposure in "${exposurearr[@]}" 
do
    for outcome in "${outcomearr[@]}"
    do
        for chr in {1..22}
        do
            cat > pbsscripts/prune.${exposure}.${outcome}.${chr}.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=16gb,walltime=14400
#PBS -N prune.${exposure}.${outcome}.${chr}
cd \$PBS_O_WORKDIR

module load intel/perflibs/64 R/3.6.1
Rscript ${DIR}/LDpruneCausal.R $exposure $outcome $chr
Rscript ${DIR}/LDpruneCausal.R $outcome $exposure $chr


EOF
            msub pbsscripts/prune.${exposure}.${outcome}.${chr}.pbs
            sleep 2
        done
    done
done


#########################################################
# rerun

cat prune.*.e* | grep Killed | cut -f 4 -d "R" | \
    sed -e 's/^ *//g' > failed_runs.txt

N=`wc -l failed_runs.txt | cut -f 1 -d " "`

for i in $(seq $N)
do 
    exposure=`tail -${i} failed_runs.txt | head -1 | cut -f 1 -d " "`
    outcome=`tail -${i} failed_runs.txt | head -1 | cut -f 2 -d " "`
    chr=`tail -${i} failed_runs.txt | head -1 | cut -f 3 -d " "`
    echo $exposure $outcome $chr
      cat > pbsscripts/pruneRe.${exposure}.${outcome}.${chr}.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=20gb,walltime=14400
#PBS -N prune.${exposure}.${outcome}.${chr}
cd \$PBS_O_WORKDIR

module load intel/perflibs/64 R/3.6.1
Rscript ${DIR}/LDpruneCausal.R $exposure $outcome $chr

EOF
       msub pbsscripts/pruneRe.${exposure}.${outcome}.${chr}.pbs
       sleep 2

done

###########################################################
# -----------------------------------------------
#
# concatenate prunes
#



exposurearr=(lamin ilamin lamax ilamax latef laaef lapef)
outcomearr=(AF HF AS AIS CES)

for exposure in "${exposurearr[@]}" 
do
    for outcome in "${outcomearr[@]}"
    do
        echo "prunedSnps/pruned.${exposure}_${outcome}_chr*.txt  > catprunedSnps/pruned.${exposure}_${outcome}_all.txt"
        cat ${DIR}/prunedSnps/pruned.${exposure}_${outcome}_chr*.txt  > ${DIR}/catprunedSnps/pruned.${exposure}_${outcome}_all.txt


        echo "prunedSnps/pruned.${outcome}_${exposure}_chr*.txt  > catprunedSnps/pruned.${outcome}_${exposure}_all.txt"
        cat ${DIR}/prunedSnps/pruned.${outcome}_${exposure}_chr*.txt  > ${DIR}/catprunedSnps/pruned.${outcome}_${exposure}_all.txt

    done
done



# -----------------------------------------------
#
# Run causal
#



exposurearr=(AF HF AS AIS CES)
outcomearr=(lamin ilamin lamax ilamax latef laaef lapef)


for exposure in "${exposurearr[@]}"
do
    for outcome in "${outcomearr[@]}"; do
            cat > pbsscripts/causal.${exposure}.${outcome}.pbs <<EOF

#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=2,mem=16gb,walltime=14400
#PBS -N causal.${exposure}_${outcome}
cd \$PBS_O_WORKDIR

module load intel/perflibs/64 R/3.6.1
Rscript ${DIR}/causalAnalysis.R $exposure $outcome
Rscript ${DIR}/causalAnalysis.R $outcome $exposure

EOF
            echo "causal.${exposure}.${outcome}"
            msub pbsscripts/causal.${exposure}.${outcome}.pbs
            sleep 2


    done
done


Rscript ${DIR}/causalAnalysis.R AF CES




# -----------------------------------------------
#
# Run LCV
#



${DIR}/runLCV.sh

Rscript lcvAnalysis.R $exposure $outcome
