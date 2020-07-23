#
# 4) Train
#
# ---------------------------------

library(snpnet)
library(data.table)

configs <- list(
    plink2.path = "/home/people/claahl/bin/plink2", 
    zstdcat.path = "/home/people/claahl/.conda/pkgs/zstd-1.3.7-h502d103_1/bin/zstdcat",
    use.glmnetPlus = FALSE,
    num.snps.batch = 9000,
    results.dir = "results",
    meta.dir = "meta",
    early.stopping = FALSE,
    nlams.init = 20,
    save = TRUE,
    glmnet.thresh = 1e-10    
)

## for (name in names(configs)) {
##     tryCatch(system(paste(configs[[name]], "-h"), ignore.stdout = T),
##              condition = function(e) cat("Please add", configs[[name]], "to PATH, or modify the path in the configs list.")
##              )
## }


genotype.pfile <- "/home/projects/cu_10039/projects/allCardiacMRI/modules/prs_snpnetLasso_200709/data/ukbMriSubset.train"
phenotype.file <- "/home/projects/cu_10039/projects/allCardiacMRI/modules/prs_snpnetLasso_200709/data/phenTrain.sort.phe"

tmp = read.table(phenotype.file, header = T)
tmp2 = read.table("data/ukbMriSubset.train.psam", header = F)


phenotype <- "ilamax"
covariates <- c("age", "sex",paste0("PC", 1:10))
#covariates <- c(paste0("bPC", 1:10))
fitSnpnet <- snpnet(
    genotype.pfile = genotype.pfile,
    phenotype.file = phenotype.file,
    phenotype = phenotype,
    covariates = covariates,
    split.col = "split",
    configs = configs,
    alpha = 1
) # we hide the intermediate messages



ids <- readIDsFromPsam(paste0(genotype.pfile, '.psam'))
phe <- readPheMaster(phenotype.file, ids, "gaussian", covariates, phenotype, NULL, NULL, configs)
vars <- dplyr::mutate(dplyr::rename(data.table::fread(cmd=paste0(configs[['zstdcat.path']], ' ', paste0(genotype.pfile, '.pvar.zst'))), 'CHROM'='#CHROM'), VAR_ID=paste(ID, ALT, sep='_'))$VAR_ID
#vars <- read.table("data/ukbMriSubset.train.bim",stringsAsFactors = F)



beta = fitSnpnet$beta[[which.max(fitSnpnet$metric.val)]]
varsID = names(beta[!beta == 0])
betaVal = beta[!beta == 0]


#varsID = gsub("_\\w+$","",names(beta[!beta == 0]))
idxVars = na.omit(match(varsID,vars))
varsIDrs = varsID[-c(1:12)][order(idxVars)]



pvar <- pgenlibr::NewPvar(paste0(genotype.pfile, '.pvar.zst'))
pgen <- pgenlibr::NewPgen(paste0(genotype.pfile, '.pgen'), pvar = pvar, sample_subset = NULL)
data.X <- pgenlibr::ReadList(pgen, idxVars, meanimpute=T)



prepareFeatures <- function(pgen, vars, names, stat) {
    idxVars = na.omit(match(varsID, vars))
    buf <- pgenlibr::ReadList(pgen, idxVars, meanimpute=F)
    features.add <- as.data.table(buf)
    colnames(features.add) <- names
    for (j in 1:length(names)) {
        set(features.add, i=which(is.na(features.add[[j]])), j=j, value=stat[["means"]][names[j]])
    }
    features.add
}


features <- prepareFeatures(pgen, vars,  varsID[-c(1:12)], fitSnpnet$stats)
features = as.matrix(features)

prs = scale(features %*% betaVal[-c(1:12)])

model.matrix = cbind(as.matrix(tmp[,covariates]), features)

intercept = fitSnpnet$a0[[which.max(fitSnpnet$metric.val)]]  
pred = intercept + (model.matrix %*% betaVal)

(sum(pred - tmp$lamin)^2)/nrow(model.matrix)


cor(pred[tmp$split == 'val'], tmp$lamin[tmp$split == 'val'])

cor(pred[tmp$split == 'val'], tmp$lamin[tmp$split == 'val'])


y = phe$height_scale

summary(lm(y ~ tmp$age + tmp$sex, subset = tmp$split == "train"))
summary(lm(y ~ data.X[,1:10] + tmp$age + tmp$sex, subset = tmp$split == "train"))
summary(lm(y ~ prs , subset = tmp$split == "train"))
summary(lm(y ~ prs + tmp$age + tmp$sex, subset = tmp$split == "train"))


summary(lm(y ~ tmp$age + tmp$sex, subset = tmp$split == "val"))
summary(lm(y ~ data.X[,1:10] + tmp$age + tmp$sex, subset = tmp$split == "val"))
summary(lm(y ~ prs , subset = tmp$split == "val"))
summary(lm(y ~ prs + tmp$age + tmp$sex, subset = tmp$split == "val"))


summary(glm(tmp$af ~ prs +tmp$age + tmp$sex, subset = tmp$split == "val"), family = binomial)


pred = predict_snpnet(fit = fitSnpnet,
                      new_genotype_file = "data/ukbMriSubset.test",
                      new_phenotype_file = "data/phenTest.sort.phe",
                      phenotype = "lamin",
                      covariate_names = covariates,
                      configs = list(zstdcat.path = "/home/people/claahl/.conda/pkgs/zstd-1.3.7-h502d103_1/bin/zstdcat", zcat.path="/home/people/claahl/.conda/pkgs/zstd-1.3.7-h502d103_1/bin/zcat"))




phenotype, gcount_path = NULL, meta_dir = NULL, meta_suffix = ".rda", covariate_names = NULL,
  split_col = NULL, split_name = NULL, idx = NULL, family = NULL, snpnet_prefix = "output_iter_",
  snpnet_suffix = ".RData", snpnet_subdir = "results", configs = list(zstdcat.path = "zstdcat",
  zcat.path='zcat'))
