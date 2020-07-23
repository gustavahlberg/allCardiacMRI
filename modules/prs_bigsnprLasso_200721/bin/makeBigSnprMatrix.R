# 
# make big snpr matrix
#
# ------------------------



system.time(
  rds <- bigsnpr::snp_readBGEN(
    bgenfiles = glue::glue("../../data/subsetbgen/subset_ukb_imp_chr{chr}_v3.bgen", chr = 1:22),
    list_snp_id = list_snp_id,
    backingfile = "data/UKB_imp_lacmr",
    ind_row = ind.indiv,
    bgi_dir = "../../data/subsetbgen/",
    ncores = 10
  )
) # 2H


###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
