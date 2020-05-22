#                                                                                                   
# depict
# date: 200519
#
# ------------------------------------------------------------                                      
#                                                           
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

mkdir -p ${DIR}/results
module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

module load moab


# ------------------------------------------------------------                                      
#                                                           
# lamin 
#


mkdir -p ${DIR}/results/laminSign

cat > lamin.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N lamin
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py lamin.cfg  

EOF

qsub lamin.pbs


# ------------------------------------------------------------                                      
#                                                           
# lamax
#


mkdir -p ${DIR}/results/lamaxSign

cat > lamax.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N lamax
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py lamax.cfg

EOF

qsub lamax.pbs


# ------------------------------------------------------------                                      
#                                                           
# ilamin 
#

mkdir -p ${DIR}/results/ilaminSign

cat > ilamin.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N ilamin
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py ilamin.cfg

EOF

qsub ilamin.pbs



# ------------------------------------------------------------                                      
#                                                           
# ilamax 
#


mkdir -p ${DIR}/results/ilamaxSign
cat > ilamax.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N ilamax
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py ilamax.cfg

EOF

qsub ilamax.pbs




# ------------------------------------------------------------                                      
#                                                           
# laaef 
#


mkdir -p ${DIR}/results/laaefSign
cat > laaef.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N laaef
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py laaef.cfg

EOF

qsub laaef.pbs


# ------------------------------------------------------------                                      
#                                                           
# lapef 
#


mkdir -p ${DIR}/results/lapef
cat > lapef.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N lapef
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py lapef.cfg

EOF

qsub lapef.pbs


# ------------------------------------------------------------                                      
#                                                           
# latef 
#


mkdir -p ${DIR}/results/latef
cat > latef.pbs <<EOF
#!/bin/bash
#PBS group_list=cu_10039 -A cu_10039
#PBS -m n 
#PBS -l nodes=1:ppn=8,mem=20gb:fatnode,walltime=72000
#PBS -N latef
cd \$PBS_O_WORKDIR

module unload anaconda3/4.0.0
module unload gcc/5.4.0
module load anaconda2/4.0.0
module load jre/1.8.0
module load plink2/1.90beta5.4
module load depict/1_rel194 

python src/python/depict.py latef.cfg

EOF

qsub latef.pbs



###########################################
# EOF # EOF# EOF# EOF# EOF# EOF# EOF# EOF #
###########################################

