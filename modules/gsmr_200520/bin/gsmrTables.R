#
# gsmr 
#
# ---------------------------------------------
#
# load files
#

gsmrFiles = list.files(pattern = "eff_plot.gz")

mr = gsmrFiles[3]
gsmr_data = read_gsmr_data(mr)
gsmrTab = data.frame(gsmr_data$bxy_result,
                     stringsAsFactors = F)


# ---------------------------------------------
#
# Print
#

tab = gsmrTab[-grep("CES|AIS|AS",gsmrTab$Exposure),]
tab$bxy = as.numeric(tab$bxy); tab$se = as.numeric(tab$se)
tab$p = as.numeric(tab$p); tab$n_snps = as.numeric(tab$n_snps)

write.xlsx(tab,
           file = "gsmr_5e7_results.xlsx",
           row.names = F)



