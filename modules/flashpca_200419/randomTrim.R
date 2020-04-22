
tab = read.table("genPCA/ukbMriSubset.maf.hwe.reg.ld.bim",
                 header = F,
                 stringsAsFactors = F)


idxRnd=sample(dim(tab)[1], 90e3)



write.table(tab$V2[idxRnd],
            file = "rsId_randTrim.tsv",
            row.names = F,
            col.names = F,
            quote = F)
