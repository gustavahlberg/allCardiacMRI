#
# select unrelated sample set 
# train/validation
#
# --------------------------------------------------
#
# load
#

phenoTrain = read.table("../../../cardiacMRI/data/ukbCMR.plinkPhenocovar_200509.sample",
                        stringsAsFactors = F,
                        header = T)


related = as.character(read.table("../../../cardiacMRI/modules/fastPpca_200220/results/related4_dgrs_200506.txt",
                                  stringsAsFactors = F,
                                  header = F)$V1)


# ---------------------------------------
#
# QC check
#

qc_exlucde <- (sqc2$het.missing.outliers==1 &
              sqc2$excluded.from.kinship.inference==1 &
              sqc2$excess.relatives==1 #&
            #sqc2$used.in.pca.calculation==1
)

qc2 <- sqc2[qc_exlucde,]
any(phenoTrain$FID %in% qc2$eid)


# ---------------------------------------
#
# subset to etnically matched
#



phenoTrain = phenoTrain[!is.na(phenoTrain$rntrn_lamax),]
phenoTrain = phenoTrain[-which(phenoTrain$FID %in% related),]

qc2sub = sqc2[!qc_exlucde,]
qc2sub = qc2sub[qc2sub$eid %in% phenoTrain$FID,]
qcheader = colnames(qc2sub)
qcheader[grep("PC",qcheader)] = paste0("b",qcheader[grep("PC",qcheader)])
colnames(qc2sub) = qcheader

row.names(qc2sub) <- as.character(qc2sub$eid)

qc2sub = qc2sub[as.character(phenoTrain$FID),]
all(qc2sub$eid == phenoTrain$FID)

phenoTrain = cbind(phenoTrain,qc2sub[, paste0("bPC",1:10)])

# split col
set.seed(42)
phenoTrain$split = "train"
idxVal = sample(seq(nrow(phenoTrain)),floor(0.2*nrow(phenoTrain)))
phenoTrain$split[idxVal] <- 'val'
table(phenoTrain$split)

phe.fn = paste0("phenoTrain_", format(Sys.time(),"%y%m%d"),".phe")

write.table(x = phenoTrain,
            file = "data/phenoTrain.phe",
            sep = "\t",
            row.names = F,
            col.names = T,
            quote = F)



#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################

ids <- readIDsFromPsam(paste0(genotype.pfile, '.psam'))
phe <- readPheMaster(phenotype.file, ids, "gaussian", covariates, phenotype, NULL, NULL, configs)
phe$s
fit_snpnet_ent <- snpnet(
  genotype.pfile = genotype.pfile,
  phenotype.file = phenotype.file,
  phenotype = phenotype,
  covariates = covariates,
  alpha = 0.5, # elastic-net
  split.col = "split", # the sample phenotype file contains a column specifying the training/validation subsets
  configs = configs
)

library(snpnet)
configs <- list(
  plink2.path = "~/Downloads/plink-ng-2.00a2.3/2.0/bin/plink2", # path to plink2 program
  zstdcat.path = "/usr/local/bin/zstdcat" # path to zstdcat program
)
# check if the provided paths are valid
for (name in names(configs)) {
  tryCatch(system(paste(configs[[name]], "-h"), ignore.stdout = T),
           condition = function(e) cat("Please add", configs[[name]], "to PATH, or modify the path in the configs list.")
  )
}


read.table(phenotype.file)

genotype.pfile <- file.path(system.file("extdata", package = "snpnet"), "sample")
phenotype.file <- system.file("extdata", "sample.phe", package = "snpnet")
phenotype <- "QPHE"
covariates <- c("age", "sex", paste0("PC", 1:10))
fit_snpnet <- snpnet(
  genotype.pfile = genotype.pfile,
  phenotype.file = phenotype.file,
  phenotype = phenotype,
  covariates = covariates,
  configs = configs
) #



ids <- readIDsFromPsam(paste0(genotype.pfile, '.psam'))
phe <- readPheMaster(phenotype.file, ids, "gaussian", covariates, phenotype, NULL, NULL, configs)
vars <- readRDS(system.file("extdata", "vars.rds", package = "snpnet"))
pvar <- pgenlibr::NewPvar(paste0(genotype.pfile, '.pvar.zst'))
pgen <- pgenlibr::NewPgen(paste0(genotype.pfile, '.pgen'), pvar = pvar, sample_subset = NULL)
data.X <- pgenlibr::ReadList(pgen, seq_along(vars), meanimpute=F)
colnames(data.X) <- vars
p <- ncol(data.X)
pnas <- numeric(p)


for (j in 1:p) {
  pnas[j] <- mean(is.na(data.X[, j]))
  data.X[is.na(data.X[, j]), j] <- mean(data.X[, j], na.rm = T) # mean imputation
}










