genotype.pfile <- file.path(system.file("extdata", package = "snpnet"), "sample")
phenotype.file <- system.file("extdata", "sample.phe", package = "snpnet")
#dim(tmp)

phenotype <- "QPHE"
covariates <- c("age", "sex", paste0("PC", 1:10))


fit_snpnet <- snpnet(
    genotype.pfile = genotype.pfile,
    phenotype.file = phenotype.file,
    phenotype = phenotype,
    covariates = covariates,
    configs = configs
) # we hide the intermediate messages



configs[["nCores"]] <- 2
configs[["num.snps.batch"]] <- 500


fit_snpnet_ent <- snpnet(
    genotype.pfile = genotype.pfile,
    phenotype.file = phenotype.file,
    phenotype = phenotype,
    covariates = covariates,
    alpha = 0.5, # elastic-net
    split.col = "split", # the sample phenotype file contains a column specifying the training/validation subsets
    configs = configs
)
