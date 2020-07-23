freq = read.table("plink.frq",
           stringsAsFactors = F,
           header = T)

write.table(data.frame(SNP = freq$SNP,
                       P = 1 - freq$MAF),
            file = "inv.frq", row.names = FALSE, quote = FALSE)
