library(data.table)
library(Publish)
library(HDF5Array)
library(rhdf5)
library(dplyr)
library(R.utils)
library(DiagrammeR)
#library(xlsx)

PROJ_DATA="~/Projects/ManageUkbb/data/phenotypeFile/"
h5.fn <- paste(PROJ_DATA,"ukb41714.all_fields.h5", sep = '/')

sample.id <- h5read(h5.fn,"sample.id")
