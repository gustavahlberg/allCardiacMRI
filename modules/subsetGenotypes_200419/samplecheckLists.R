## sort sampleList.etn_200419.tsv

sampleData.fn="/home/projects/cu_10039/data/UKBB/Imputed/ukb43247_imp_chr1_v3_s487320.sample"
samples.fn="../../data/sampleList.etn_200419.tsv"



sampleData = read.table(file = sampleData.fn,
                        stringsAsFactors = F,
                        header = T)
     
samples = read.table(file = samples.fn,
                        stringsAsFactors = F,
                        header = F)$V1

subSampleData = sampleData[sampleData$ID_1 %in% samples,]


head(rbind(sampleData[1,], subSampleData))

subSampleData <- rbind(sampleData[1,], subSampleData)

write.table(x = subSampleData,
            file = "../../data/ukbCMR.ordered.etn_200419.sample",
            col.names = T,
            row.names = F,
            quote = F)


#############################################################


test1.fn = "sanityCheck/test.ped"
test2.fn = "sanityCheck/test2.ped"


test1 = read.table(file = test1.fn,
                   header = F,
                   sep = "\t",
                   stringsAsFactors = F)


test2 = read.table(file = test2.fn,
                   header = F,
                   sep = "\t",
                   stringsAsFactors = F)




all(test2$V7 == test1$V7)
all(test2$V8 == test1$V8)
all(test2$V9 == test1$V9)


all(test2$V2 == subSampleData$ID_1[-1])
all(test1$V2 == subSampleData$ID_1[-1])
all(test1$V2 == test2$V2)

