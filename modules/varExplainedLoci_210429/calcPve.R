# ---------------------------------------------
#
# Calc. PVE
#
# PVE: 
# 2βˆ2MAF(1 − MAF)/ (2βˆ2MAF(1 − MAF) + (se(βˆ))2 2NMAF(1 − MAF))
# ---------------------------------------------
#
#
# function pve
#

pve <- function(beta, eaf, se, N) {
  #pve <- (beta^2)*2*eaf*(1-eaf)/( ((beta^2)*2*eaf*(1-eaf)) + ((se^2)*N*2*eaf*(1-eaf)) )
  pve <- (beta^2)*2*eaf*(1-eaf)
  return(pve)
}


# ---------------------------------------------
#
#
# calc pve for each trait
#

varExpained <- list()
phenos = c("ilamin", "ilamax", "laaef", "lapef", "latef")
pve_trait <- list()

for(pheno in phenos) {
  trait <- gwas_loci[[pheno]]
  
  rownames(trait) <- trait$SNP
  
  pve_snp <- apply(trait, 1, function(x) {
    pve(as.numeric(x['bstd']), as.numeric(x['A1FREQ']), 
        as.numeric(x['sestd']), as.numeric(x['N']))
  })
  
  pve_tot <- sum(pve_snp); names(pve_tot) <- "total"
  pve_trait[[pheno]] <- c(pve_snp, pve_tot)

}

pve_trait[[1]]*100


# ---------------------------------------------
#
#
# Fstat
#

fstat <- function(R2, N, k) {
   ((N-k-1)/k)*(R2/(1-R2))
}

N = 35658

gwas_fstat <- sapply(1:5, function(i){
  k = nrow(gwas_loci[[i]])
  fstat(R2 = pve_trait[[i]], N, c(rep(1,k),k) )
})

names(gwas_fstat) <- phenos



data.frame(PVE = pve_trait[[i]],
           fstat = gwas_fstat[[i]])



