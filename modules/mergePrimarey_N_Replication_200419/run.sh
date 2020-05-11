#
#
# Merge phenotype files from primary and rep datasets
#
# ---------------------------------------------
#
# configs
# 




# ---------------------------------------------
#
# 1. merge
# 

Rscript mergePrimary_N_Replication.R 

# ---------------------------------------------
#
# replace rank transformations rntrn and PC's
# 


Rscript replace_rntrnNpc.R
