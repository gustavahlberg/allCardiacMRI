#
# select reference panel
#
# ---------------------------------------------


AFGRSrefPanel = as.character(read.table("../../../AFGRS/data/samplesCojo.list",
                                        stringsAsFactors = F)$V1)


fam = read.table("../../../AFGRS/modules/cojoAnalysis_191010/subsetGenotypes/cojo_1.fam",
                 stringsAsFactors = F)

AFGRSrefPanel = as.character(read.table("../../../AFGRS/modules/",
                                        stringsAsFactors = F)$V1)


sampleMRI = as.character(read.table("../../data/sampleList.all.etn_200506.tsv",
                                    stringsAsFactors = F)$V1)


# -----------------------------------------------------------
#
# fix fam
#


for(i in 1:22) {
    
    fam.fn = paste0("../../../AFGRS/modules/cojoAnalysis_191010/subsetGenotypes/cojo_",
                    i,".fam")
    fam = read.table(fam.fn,
                     stringsAsFactors = F)
    fam$V1 <- fam$V2
    write.table(fam,
                file = fam.fn,
                quote = F,
                row.names = F,
                col.names = F
                )
}


# ------------------------------------------------------
#
# select
#


sum(AFGRSrefPanel %in% sampleMRI)
refPanel = AFGRSrefPanel[-which(AFGRSrefPanel %in% sampleMRI)]

refPanel = sample(refPanel, size = 12000, replace = F)




# ------------------------------------------------------
#
# print
#


write.table(refPanel,
            file = "../../data/refsamplesGSMR.tsv",
            row.names = F,
            col.names = F,
            quote = F)
