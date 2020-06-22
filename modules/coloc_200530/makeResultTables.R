#
# make result tables
#
# --------------------------------------
#
# pp results 
#


res_lv_PP = lapply(lvColocList, function(x) {
  pp = sapply(x, function(z) z[[1]][6])
  data.frame(geneId = names(x), PP = unlist(pp))
  })

res_aa_PP = lapply(aaColocList, function(x) {
  pp = sapply(x, function(z) z[[1]][6])
  data.frame(geneId = names(x), PP = unlist(pp))
})


res_lv_PP = do.call(rbind, res_lv_PP)
res_aa_PP = do.call(rbind, res_aa_PP)

res_lv_PP$locus = gsub("\\.ENSG.+\\.abf","",row.names(res_lv_PP))
res_lv_PP$pheno = gsub("rntrn_|_\\d\\.chr.+","",res_lv_PP$locus )
res_aa_PP$locus = gsub("\\.ENSG.+\\.abf","",row.names(res_aa_PP))
res_aa_PP$pheno = gsub("rntrn_|_\\d\\.chr.+","",res_aa_PP$locus )


res_lv_PP$tissue = "left_ventricle"
res_aa_PP$tissue = "atrial_appendage"

resPP = rbind(res_aa_PP, res_lv_PP)

# -----------------------------------------------
#
# add hgnc
# 

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
genes = gsub("\\..+","",unique(resPP$geneId))

glist <- getBM(filters= "ensembl_gene_id", 
               attributes= c("ensembl_gene_id","hgnc_symbol"),
               values=genes,
               mart= mart)


resPP$hgnc = sapply(resPP$geneId, function(x){
  glist$hgnc_symbol[glist$ensembl_gene_id == gsub("\\..+","",x)]
})


resPP$hgnc[resPP$hgnc == ""] <- "RP11-236B18.2"
resPP['rntrn_laaef_6.chr8',]$hgnc <- "RP11-10A14.4"

resPP = resPP[order(resPP$PP, decreasing = T),]

# add sentinel
resPP$sentinel = sapply(resPP$locus, function(x) {
  locus = loci[[x]]
  locus$rsid[which.min(locus$pval)]
})


# -----------------------------------------
#
# print pp result
# 

write.table(file = "results/colocPP_Results_200605.tab",
      x = resPP,
      row.names = F,
      col.names = T,
      quote = F)

write.xlsx(file = "results/coloc_Results_200605.xlsx",
           x = resPP,
           row.names = F,
           col.names = T,
           sheetName = "PP_results_coloc"
           )




# -----------------------------------------------
#
# print 95 credible snps
# 
# save objects


save(aaColocList,lvColocList, file = "colocResults.rda")


credibleSnpsLV = do.call(rbind, lapply(lvColocList, function(x) {
  x = lapply(x, function(z) {
    z[[3]]
  })
  do.call(rbind,x)
  }))

credibleSnpsAA = do.call(rbind, lapply(aaColocList, function(x) {
  x = lapply(x, function(z) {
    z[[3]]
  })
  do.call(rbind,x)
}))


unique(as.character(credibleSnpsLV$rsid), as.character(credibleSnpsAA$rsid))



