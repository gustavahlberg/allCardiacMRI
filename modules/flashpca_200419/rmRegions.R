#
# Remove regions
#
# - no AT/GC SNPs (strand ambiguous SNPs)
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)
#
# -----------------------------------------------------------
#
# load data
# 


tab = read.table("intermediate/ukbMriSubset.maf.hwe.bim",
                 header = F,
                 stringsAsFactors = F)

# -----------------------------------------------------------
#
# AT/GC SNPs (strand ambiguous SNPs)
# 

sum((tab$V5 == "A" & tab$V6 == "T") | (tab$V5 == "T" & tab$V6 == "A") |
    (tab$V5 == "G" & tab$V6 == "C") | (tab$V5 == "C" & tab$V6 == "G"))


idxStrAmb = which((tab$V5 == "A" & tab$V6 == "T") | (tab$V5 == "T" & tab$V6 == "A") |
                  (tab$V5 == "G" & tab$V6 == "C") | (tab$V5 == "C" & tab$V6 == "G"))


# -----------------------------------------------------------
#
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)

sum(tab$V1 == 6 & (tab$V4 < 25e6 & tab$V4 < 35e6))
sum(tab$V1 == 8 & (tab$V4 < 7e6 & tab$V4 < 13e6))

idxMhc = which(tab$V1 == 6 & (tab$V4 < 25e6 & tab$V4 < 35e6))
idxInv8 =sum(tab$V1 == 8 & (tab$V4 < 7e6 & tab$V4 < 13e6))



# -----------------------------------------------------------
#
# combine and print
# 

idx = unique(c(idxStrAmb,idxMhc,idxInv8))

write.table(tab$V2[idx],
            file = "rsId_StrAmbInv8MHC.tsv",
            row.names = F,
            col.names = F,
            quote = F)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################






