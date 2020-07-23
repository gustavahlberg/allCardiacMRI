configs <- list(
    plink2.path = "/home/people/claahl/bin/plink2", # path to plink2 program
    zstdcat.path = "/home/people/claahl/.conda/pkgs/zstd-1.3.7-h502d103_1/bin/zstdcat" # path to zstdcat program
)

# check if the provided paths are valid
for (name in names(configs)) {
    tryCatch(system(paste(configs[[name]], "-h"), ignore.stdout = T),
             condition = function(e) cat("Please add", configs[[name]], "to PATH, or modify the path in the configs list.")
             )
}
