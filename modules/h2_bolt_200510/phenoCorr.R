#
# load h2 and gen corr.
#
# ------------------------------

cor.test.plus <- function(x) {
  list(x, 
       Standard.Error = unname(sqrt((1 - x$estimate^2)/x$parameter)))
}


# ------------------------------
#
# correlation
#

phenocorrMat = cor(na.omit(df[,ph]))


#gencormat[lower.tri(phenocorrMat, diag = F)] <- signif(phenocorrMat[lower.tri(phenocorrMat, diag = F)], digits = 2)
#gencormatNum[lower.tri(phenocorrMat, diag = F)] <- phenocorrMat[lower.tri(phenocorrMat, diag = F)]


# ------------------------------
#
# standard error
#

k = 10
upper.tri(phenocorrMat, diag = T)
which(upper.tri(phenocorrMat, diag = T))
row = head(which(upper.tri(phenocorrMat, diag = T)) %% 10, -1)
col = head(1 + which(upper.tri(phenocorrMat, diag = T)) %/% 10, -1 )

sepheno = matrix(data = 0, 
                 nrow = k, 
                 ncol = k, 
                 dimnames = list(ph,ph))


for(i in 1:length(row)){
  d = na.omit(df[,ph][,c(row[i],col[i])])
  se = cor.test.plus(cor.test(d[,1],d[,2]))$Standard.Error
  sepheno[row[i],col[i]] <- se  
}


# ------------------------------
#
# standard error
#


sepheno[lower.tri(t(sepheno), diag = F)] = t(sepheno)[lower.tri(t(sepheno), diag = F)]


# ------------------------------
#
# merge
#


phenocorrMatSE = matrix(paste0(signif(phenocorrMat, digits = 2), "\n(", signif(sepheno, digits = 2),")"),
                        nrow = k, 
                        ncol = k, 
                        dimnames = list(ph,ph))

                        
diag(phenocorrMatSE) <- NA



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################







