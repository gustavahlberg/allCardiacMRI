library(data.table)
library(Publish)
library(HDF5Array)
library(rhdf5)
library(dplyr)
library(R.utils)
library(DiagrammeR)
library(xlsx)

PROJ_DATA="~/Projects_2/ManageUkbb/data/phenotypeFile/"
h5.fn <- paste(PROJ_DATA,"ukb41714.all_fields.h5", sep = '/')


#############################################################

library(GMMAT)

pheno.file <- system.file("extdata", "pheno.txt", package = "GMMAT")
pheno <- read.table(pheno.file, header = TRUE)
GRM.file <- system.file("extdata", "GRM.txt.bz2", package = "GMMAT")
GRM <- as.matrix(read.table(GRM.file, check.names = FALSE))


model0 <- glmmkin(disease ~ age + sex, data = pheno, kins = GRM,
                  id = "id", family = binomial(link = "logit"))

group.file <- system.file("extdata", "SetID.withweights.txt", package = "GMMAT")
geno.file <- system.file("extdata", "geno.gds", package = "GMMAT")


SMMAT(model0, group.file = group.file, geno.file = geno.file,
      MAF.range = c(1e-7, 0.5), miss.cutoff = 1, method = "davies",
      tests = c("O", "E"))

read.table(group.file)

gds = seqOpen(geno.file)
af = alleleFrequency(gds)

