computeProduct <- function(residual, pfile, vars, stats, configs, iter) {
  time.computeProduct.start <- Sys.time()
  snpnetLogger('Start computeProduct()', indent=2, log.time=time.computeProduct.start)

  gc_res <- gc()
  if(configs[['KKT.verbose']]) print(gc_res)

  snpnetLogger('Start plink2 --variant-score', indent=3, log.time=time.computeProduct.start)
  dir.create(file.path(configs[['results.dir']], configs[["save.dir"]]), showWarnings = FALSE, recursive = T)

  residual_f <- file.path(configs[['results.dir']], configs[["save.dir"]], paste0("residuals_iter_", iter, ".tsv"))

  # write residuals to a file
  residual_df <- data.frame(residual)
  colnames(residual_df) <- paste0('lambda_idx_', colnames(residual))
  residual_df %>%
    tibble::rownames_to_column("ID") %>%
    tidyr::separate(ID, into=c('#FID', 'IID'), sep='_') %>%
    data.table::fwrite(residual_f, sep='\t', col.names=T)

  # Run plink2 --geno-counts
  cmd_plink2 <- paste(
    configs[['plink2.path']],
    '--threads', configs[['nCores']],
    '--pfile', pfile, ifelse(configs[['vzs']], 'vzs', ''),
    '--read-freq', paste0(configs[['gcount.full.prefix']], '.gcount'),
    '--keep', residual_f,
    '--out', stringr::str_replace_all(residual_f, '.tsv$', ''),
    '--variant-score', residual_f, 'zs', 'bin'
  )
  if (!is.null(configs[['mem']])) {
    cmd_plink2 <- paste(cmd_plink2, '--memory', as.integer(configs[['mem']]) - ceiling(sum(as.matrix(gc_res)[,2])))
  }

  system(cmd_plink2, intern=F, wait=T)

  prod.full <- readBinMat(stringr::str_replace_all(residual_f, '.tsv$', '.vscore'), configs)
  if (! configs[['save.computeProduct']] ) system(paste(
      'rm', residual_f, stringr::str_replace_all(residual_f, '.tsv$', '.log'), sep=' '
  ), intern=F, wait=T)

  snpnetLoggerTimeDiff('End plink2 --variant-score.', time.computeProduct.start, indent=4)

  rownames(prod.full) <- vars
  if (configs[["standardize.variant"]]) {
      for(residual.col in 1:ncol(residual)){
        prod.full[, residual.col] <- apply(prod.full[, residual.col], 2, "/", stats[["sds"]])
      }
  }
  prod.full[stats[["excludeSNP"]], ] <- NA
  snpnetLoggerTimeDiff('End computeProduct().', time.computeProduct.start, indent=3)
  prod.full
}



readBinMat <- function(fhead, configs){
    # This is a helper function to read binary matrix file (from plink2 --variant-score zs bin)
    rows <- data.table::fread(cmd=paste0(configs[['zstdcat.path']], ' ', fhead, '.vars.zst'), head=F)$V1
    cols <- data.table::fread(paste0(fhead, '.cols'), head=F)$V1
    bin.reader <- file(paste0(fhead, '.bin'), 'rb')
    M = matrix(
        readBin(bin.reader, 'double', n=length(rows)*length(cols), endian = configs[['endian']]),
        nrow=length(rows), ncol=length(cols), byrow = T
    )
    close(bin.reader)
    colnames(M) <- cols
    rownames(M) <- rows
    if (! configs[['save.computeProduct']]) system(paste(
        'rm', paste0(fhead, '.cols'), paste0(fhead, '.vars.zst'),
        paste0(fhead, '.bin'), sep=' '
    ), intern=F, wait=T)
    M
}
