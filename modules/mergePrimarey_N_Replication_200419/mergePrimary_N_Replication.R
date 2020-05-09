#
# merge sample sheets from primary and replication data sheets
# sort after original sample file
# ----------------------------------------------------------------
#
# list files
#

sampleData.fn="/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample"

repDIR = '../../../repCardiacMRI/data/'
priDIR = '../../../cardiacMRI/data/'

repSL.fn = paste0(repDIR, "sampleList.etn_200506.tsv")
repSample.fn=paste0(repDIR, "ukbCMR.rep.snpTest_200506.sample")
repPheno.fn=paste0(repDIR, "ukbCMR.rep.boltlmm_200506.sample")
repExclude.fn=paste0(repDIR, "sample2exclude.rep.snpTest_200506.list")

priSL.fn= paste0(priDIR, "sampleList.etn_200219.tsv")
priSample.fn=paste0(priDIR,"ukbCMR.snpTest_200316.sample")
pripheno.fn=paste0(priDIR,"ukbCMR.boltlmm_200316.sample")
priExclude.fn=paste0(priDIR, "sample2exclude.snpTest_200316.list")

allSL.fn= "../../data/sampleList.all.etn_200506.tsv"
allSample.fn= "../../data/ukbCMR.all.snpTest_200506.sample"
allPheno.fn= "../../data/ukbCMR.all.boltlmm_200506.sample"
allExclude.fn= "../../data/sample2exclude.all.snpTest_200506.list"

# ----------------------------------------------------------------
#
# sample list
#

sampleOrg = read.table(sampleData.fn, header = T, stringsAsFactors = F)

repSl = read.table(repSL.fn, header = F, stringsAsFactors = F)
priSl = read.table(priSL.fn, header = F, stringsAsFactors = F)
allSl = c(repSl$V1, priSl$V1)
subSampleData = sampleOrg[sampleOrg$ID_1 %in% allSl,]

write.table(subSampleData$ID_1,
            file = allSL.fn,
            col.names = F,
            row.names = F,
            quote = F)


# ----------------------------------------------------------------
#
# snpTest
#

repSample = read.table(repSample.fn, header = T, stringsAsFactors = F)
priSample = read.table(priSample.fn, header = T, stringsAsFactors = F)
allSample = rbind(repSample,priSample[-1,])

rownames(allSample) <- as.character(allSample$ID_1)
subSampleData = sampleOrg[sampleOrg$ID_1 %in% allSample$ID_1,]

allSample = allSample[as.character(subSampleData$ID_1),]

write.table(allSample,
            file = allSample.fn,
            col.names = T,
            row.names = F,
            quote = F)

# ----------------------------------------------------------------
#
# bolt
#

repPheno = read.table(repPheno.fn, header = T, stringsAsFactors = F)
priPheno = read.table(pripheno.fn, header = T, stringsAsFactors = F)
allPheno = rbind(repPheno,priPheno)

rownames(allPheno) <- as.character(allPheno$IID)
subSampleData = sampleOrg[sampleOrg$ID_1 %in% allPheno$IID,]

allPheno = allPheno[as.character(subSampleData$ID_1),]

write.table(allPheno,
            file = allPheno.fn,
            col.names = T,
            row.names = F,
            quote = F)



# ----------------------------------------------------------------
#
# exclude
#

repExclude = read.table(repExclude.fn, header = F, stringsAsFactors = F)
priExclude = read.table(priExclude.fn, header = F, stringsAsFactors = F)
allExclude = c(repExclude$V1, priExclude$V1)

subSampleData = sampleOrg[sampleOrg$ID_1 %in% allExclude,]

write.table(subSampleData$ID_1,
            file = allExclude.fn,
            col.names = F,
            row.names = F,
            quote = F)


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################




