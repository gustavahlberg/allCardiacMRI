for(i in 1:22) {
    file = paste0("https://zenodo.org/record/1464357/files/chr",i,"_AF0.05_0.1.RDS?download=1")
    destfile = paste0("data/chr",i,"_AF0.05_0.1.RDS")
    download.file(file , destfile = destfile)

    file = paste0("https://zenodo.org/record/1464357/files/chr",i,"_AF0.05_snpdata.RDS?download=1")
    destfile = paste0("data/chr",i,"_AF0.05_snpdata.RDS")
    download.file(file, destfile=destfile)
}
