#
# load h2 and gen corr.
#
# ------------------------------
#
# make matrix
#

grp = 'Variance component 1:  "modelSnps"'
fns = list.files("h2results", full.names = T)
ph = c("ilamax","ilamin","laaef","lamax","lamin","lapef","latef","LVEF", "LVEDV","LVESV")
k = length(ph)

gencormat = matrix("", nrow = k, ncol = k, 
                   dimnames = list(ph,ph))
gencormatNum = matrix(0, nrow = k, ncol = k, 
                   dimnames = list(ph,ph))


# for loop
for(i in 1:length(fns)) {
  fn = fns[i]
  phenos = gsub(".log", "",unlist(strsplit(basename(fn),"_"))[3:4])
  system(paste0("bash parseh2log.sh ", fn))

  tmp = t(read.table("tmp",
                     stringsAsFactors = F,
                     header = F))

  gencormatNum[phenos[1],phenos[1]] <- tmp[1,1]
  gencormatNum[phenos[2],phenos[2]] <- tmp[1,3]
  gencormatNum[phenos[1],phenos[2]] <- tmp[1,2]
  
  gencormatNum[phenos[1],phenos[1]] <- tmp[1,1]
  gencormatNum[phenos[2],phenos[2]] <- tmp[1,3]
  gencormatNum[phenos[2],phenos[1]] <- tmp[1,2]
  
  gencormat[phenos[1],phenos[1]] <- paste(signif(tmp[1,1], 2),"\n(", signif(tmp[2,1],2), ")", sep = "")
  gencormat[phenos[2],phenos[2]] <- paste(signif(tmp[1,3], 2),"\n(", signif(tmp[2,3],2), ")", sep = "")
  gencormat[phenos[1],phenos[2]] <- paste(signif(tmp[1,2], 2),"\n(", signif(tmp[2,2],2), ")", sep = "")
  
  gencormat[phenos[1],phenos[1]] <- paste(signif(tmp[1,1], 2),"\n(", signif(tmp[2,1],2), ")", sep = "")
  gencormat[phenos[2],phenos[2]] <- paste(signif(tmp[1,3], 2),"\n(", signif(tmp[2,3],2), ")", sep = "")
  gencormat[phenos[2],phenos[1]] <- paste(signif(tmp[1,2], 2),"\n(", signif(tmp[2,2],2), ")", sep = "")
  
}


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################



