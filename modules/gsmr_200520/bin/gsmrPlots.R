#
# gsmr 
#
# ---------------------------------------------
#
# load files
#

gsmrFiles = list.files(pattern = "eff_plot.gz")

mr = gsmrFiles[3]
# gsmrTab = data.frame(gsmr_data$bxy_result,
#                      stringsAsFactors = F)


# ---------------------------------------------
#
# plot mr effects
#



source("bin/gsmr_plot.r")

gsmr_data = read_gsmr_data(mr)
gsmr_summary(gsmr_data)      # show a summary of the data
plot_gsmr_effect(gsmr_data, expo_str  = "AF",
                 outcome_str = "laaef", colors()[75]) 

plot_gsmr_pvalue(gsmr_data, expo_str  = "AF",
                 outcome_str = "laaef") 

plot_bxy_distribution(gsmr_data, expo_str  = "AF",
                 outcome_str = "laaef") 


# ---------------------------------------------
#
# Heatmap MR
#

library('pheatmap')
library(grid)
library(reshape2)

gsmrTabExpLA = gsmrTab[grep("la",gsmrTab$Exposure),]
gsmrMatExpLA = acast(gsmrTabExpLA,
                  Exposure ~ Outcome, value.var = "bxy")
gsmrMatPval = acast(gsmrTabExpLA,
                     Exposure ~ Outcome, value.var = "p")


rn = rownames(gsmrMatExpLA)
gsmrMatExpLA = apply(gsmrMatExpLA, 2, as.numeric)
gsmrMatExpLAexp = exp(gsmrMatExpLA)
rownames(gsmrMatExpLA) = rn
gsmrMatExpLANum = signif(gsmrMatExpLAexp, digits = 2)

sum(!gsmrTab$Outcome %in% c("AS","AIS","CES"))

bonfThres = 0.05/sum(!gsmrTab$Outcome %in% c("AS","AIS","CES"))



gsmrMatExpLANum[] <- paste0(gsmrMatExpLANum, "\n(",
                            format(signif(as.numeric(gsmrMatPval),1),scientific = T),")")

gsmrMatExpLANum[as.numeric(gsmrMatPval) > bonfThres] <- "*"
gsmrMatExpLANum[as.numeric(gsmrMatPval) > 0.05] <- ""


tiff(filename = "GSMR_expoLA_heatmap.tiff",
     width = 6.1, height = 6.1,
     units = 'in',
     res = 300)

col <- colorRampPalette(c("#d73027","#ffffed","#4575b4"))(256)
col <- rev(col)

# ---------------------------------------
#
# Quick edit 200731 
#

gsmrMatExpLA.bakk = gsmrMatExpLA
gsmrMatExpLANum.bakk = gsmrMatExpLANum

gsmrMatExpLA = gsmrMatExpLA[-c(4:5),]
gsmrMatExpLANum = gsmrMatExpLANum[-c(4:5),]

rownames(gsmrMatExpLA) <- c("LAmax", "LAmin", "LAAEF", "LAPEF", "LATEF")

pheatmap(gsmrMatExpLA,
         display_numbers = gsmrMatExpLANum,
         number_color = "black",
         treeheight_row = 0, 
         treeheight_col = 0, 
         cluster_rows = F, 
         cluster_cols = F,
         color = col,
         angle_col = 0,
         labels_row = rownames(gsmrMatExpLA),
         labels_col = colnames(gsmrMatExpLA),
         border_color = "white",
         fontsize_number = 10,
         fontsize_row = 10,
         fontsize_col = 10,
         width = 50,
         height = 50,
         na_col = 'white',
         legend_breaks = c(-0.6,0,0.6),
         legend_labels = c(0.5,0,2),
         cellheight=40,cellwidth=40
)

dev.off()


# ---------------------------------------------
#
# Forest MR, AF as exposure
#

mr = gsmrFiles[4]
gsmr_data = read_gsmr_data(mr)
gsmrTab = data.frame(gsmr_data$bxy_result,
                     stringsAsFactors = F)

gsmrTabExpLA = gsmrTab[grep("AF",gsmrTab$Exposure),]

gsmrTabExpLA = gsmrTabExpLA[-which(gsmrTabExpLA$Outcome == "lamin" | gsmrTabExpLA$Outcome == "lamax"),]

gsmrTabExpLA$Outcome =  c("LAmin", "LAmax", "LATEF", "LAAEF", "LAPEF")

tiff(filename = "MR_AFexpsure_LAoutcomes.tiff",
     width = 8, height = 8.5, 
     units = 'in',
     res = 300)


mypar(mar = c(4,0.5,3,1))
plot(gsmrTabExpLA$bxy, 1:nrow(gsmrTabExpLA) + 1 ,
     type = 'n',
     xlim = c(-0.5,0.2), 
     cex = 1,
     xlab = "",
     ylab = "",
     col = "black",
     bty = 'n',
     yaxt = "n",
     xaxt = "n"
)

axis(1, at = c(-0.15,-0.1,-0.05, 0,0.05, 0.1, 0.15),
     labels = c(-0.15,-0.1,-0.05, 0,0.05, 0.1, 0.15), 
     tick = TRUE, 
     las = 1,
     cex.axis = 1.1)

axis(1, at = c(-0.16,-0.15),
     labels = FALSE, 
     tick = TRUE, 
     las = 1,
     lwd.ticks = 0)

abline(v = 0, col = alpha('black', 0.4))
abline(v = -0.1, col = alpha('black', 0.05))
abline(v = -0.05, col = alpha('black', 0.05))
abline(v = 0, col = alpha('black', 0.05))
abline(v = 0.05, col = alpha('black', 0.05))
abline(v = 0.1, col = alpha('black', 0.05))

title(xlab="bxy", line = 2.3, adj = 0.7, cex.main = 1.5)

table = gsmrTabExpLA
table[,"bxy"] = as.numeric(table[,"bxy"])
table[,"se"] = as.numeric(table[,"se"])

for(k in 1:nrow(gsmrTabExpLA)) {
  #k = 1
  j = k
  i = k + 1
  
  # 95 % CI 
  lines(c(table$bxy[j] - 1.96*table$se[j], table$bxy[j] + 1.96*table$se[j]), rep(i,2),
        lwd =2, col = "black")
  
  points(table$bxy[j],i, pch = 16, cex = 2, col = "black")
  
  
  tmp = format(signif(as.numeric(table$p[j]),1), scientific = FALSE)
  if(tmp == 1) {
    num =  tmp
    name = paste(table$p1[j],"vs" ,table$p2[j])
    poly = 0
  } else {
    t = unlist(strsplit(split = "",tmp))
    ans = which(t != 0)
    poly = 2 - ans[2] 
    num =  t[ans[2]]
    name = table$Outcome[j]
  }
  
  text(-0.17,i, bquote( .(name) ~ "(P ="~.(num)~x~10^.(poly) *")"), 
       cex = 1.5, adj = c(1,0.3) )
  
  
}


dev.off()




