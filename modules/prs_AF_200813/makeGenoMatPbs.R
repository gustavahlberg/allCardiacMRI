# --------------------------------
# 
# make big snpr matrix
#
# -------------------------------

load("data/list_snp_id.rda", verbose = TRUE)
load("data/samplesOrdered.rda", verbose = TRUE)

backingfile = paste0("data/afCohort")

system.time(
    rds <- bigsnpr::snp_readBGEN(
                        bgenfiles = glue::glue("/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
                        list_snp_id = list_snp_id2,
                        backingfile = backingfile,
                        ind_row = idx_indiv,
                        bgi_dir = "/home/projects/cu_10039/data/UKBB/downloadDump/EGAD00010001474/",
                        ncores = 20
                    )
) 


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
