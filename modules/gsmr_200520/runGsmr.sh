#
# 4. run gsmr
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


module load gcta/1.92.4beta 


find subsetGenotypes/cojo_*fam | sed s/.fam// > gsmr_ref_data.txt
refData=gsmr_ref_data.txt
outcomeList=outcomes.txt


# -----------------------------------------------------------
#
# gcta regular
#

exposureList=LA_exposures.txt

cat > gsmrRegular.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=20gb:fatnode,walltime=36000
#PBS -N gsmrRegular
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
gcta64 --mbfile $refData \
    --gsmr-file $exposureList $outcomeList \
    --gsmr-direction 2 \
    --gwas-thresh 5e-7 \
    --gsmr-snp-min 5 \
    --effect-plot \
    --out LAMR_regular_5e7


gcta64 --mbfile $refData \
    --gsmr-file $exposureList $outcomeList \
    --gsmr-direction 2 \
    --gwas-thresh 5e-8 \
    --gsmr-snp-min 5 \
    --effect-plot \
    --out LAMR_regular_5e8



EOF

qsub gsmrRegular.pbs

# -----------------------------------------------------------
#
# gcta rntrn
#

exposureList=LA_exposures.rntrn.txt  


cat > gsmrRntrn.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=4,mem=20gb:fatnode,walltime=36000
#PBS -N gsmrRntrn
cd \$PBS_O_WORKDIR

module load gcta/1.92.4beta 
gcta64 --mbfile $refData \
    --gsmr-file $exposureList $outcomeList \
    --gsmr-direction 2 \
    --gwas-thresh 5e-7 \
    --gsmr-snp-min 5 \
    --effect-plot \
    --out LAMR_rntrn_5e7


gcta64 --mbfile $refData \
    --gsmr-file $exposureList $outcomeList \
    --gsmr-direction 2 \
    --gwas-thresh 5e-8 \
    --gsmr-snp-min 5 \
    --effect-plot \
    --out LAMR_rntrn_5e8


EOF

qsub gsmrRntrn.pbs

################################################
# EOF # EOF# EOF# EOF# EOF# EOF# EOF# EOF# EOF #
################################################




# # -----------------------------------------------------------
# #
# # gcta mixed
# #

# exposureList=LA_exposures.mixed.txt  

# cat > gsmrMixed.pbs <<EOF
# #!/bin/bash
# #PBS group_list=cu_10039 -A cu_10039
# #PBS -m n 
# #PBS -l nodes=1:ppn=4,mem=20gb:fatnode,walltime=36000
# #PBS -N gsmrMixed
# cd \$PBS_O_WORKDIR

# module load gcta/1.92.4beta 

# module load gcta/1.92.4beta 
# gcta64 --mbfile $refData \
#     --gsmr-file $exposureList $outcomeList \
#     --gsmr-direction 2 \
#     --gwas-thresh 5e-7 \
#     --gsmr-snp-min 5 \
#     --effect-plot \
#     --out LAMR_mixed_5e7


# gcta64 --mbfile $refData \
#     --gsmr-file $exposureList $outcomeList \
#     --gsmr-direction 2 \
#     --gwas-thresh 5e-8 \
#     --gsmr-snp-min 5 \
#     --effect-plot \
#     --out LAMR_regular_5e8



# EOF

qsub gsmrMixed.pbs
