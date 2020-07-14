
res.fns = list.files(path = "causalResults", full.names = T)
causalRes = list()


for (res.fn in res.fns) {
  print(res.fn)
  load(res.fn)
  phenos = gsub("rescausal_|.Rdata","",basename(res.fn))
  res$elpd$p = pnorm(res$elpd$z)
  causalRes[[phenos]] <- res$elpd
}


causalRes
