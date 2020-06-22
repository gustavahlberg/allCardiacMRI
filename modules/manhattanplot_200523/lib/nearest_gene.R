nearest_gene <- function(sentinel, genelist){
  #sentinel = loci[1,]
  #sentinel = data.frame(t(sentinel), stringsAsFactors = F)

  genelistchr = genelist[genelist$CHR  == as.numeric(sentinel['chr']),]
  idxStart = which.min(abs(genelistchr$START - as.numeric(sentinel['bp'])))
  idxEnd = which.min(abs(genelistchr$END - as.numeric(sentinel['bp'])))
  
  x = genelistchr[c(idxStart, idxEnd),]
  mat = abs(x[, 2:3] - as.numeric(sentinel['bp']))
  
  dist2gene = apply(mat, 1, min)
  idxstrEnd = which.min(dist2gene)
  
  return(x[idxstrEnd,])
  
}

