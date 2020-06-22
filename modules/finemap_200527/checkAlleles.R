tmp = read.table("output.vcf",
                 stringsAsFactors = F)

if(any(tmp$V4 == tmp$V5)) {
  tmp = tmp[-which(tmp$V4 == tmp$V5),]
}

write.table(tmp,
            file = "tmp.vcf",
            sep = "\t",
            quote = F,
            row.names = F,
            col.names = F)
