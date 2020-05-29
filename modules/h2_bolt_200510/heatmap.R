#
# 
# Heatmap
#
# ---------------------------------------------------------


library('pheatmap')
library(grid)
col<- colorRampPalette(c("red", "white", "blue"))(256)

h2matCol = phenocorrMat
h2mat = phenocorrMatSE

# h2matCol = gencormatNum
# h2mat = gencormat
#h2mat[lower.tri(h2mat,diag = T)] <- ""


h2mat[lower.tri(h2mat,diag = T)] <- ""
h2matCol[lower.tri(h2matCol,diag = T)] <- NA


# for(i in 1:10)
#   h2matCol[i,i] <- NA 
# 
# h2mat = format(round(h2mat, digits=2), nsmall = 2) 
# for(i in 1:10)
#   h2mat[i,i] <- paste("(",as.character(h2mat[i,i]),")")


tiff(filename = "results/PhenotypeCorrelationHeatmap.tiff",
     width = 6.1, height = 6.1,
     units = 'in',
     res = 300)

pheatmap(h2matCol,
         display_numbers = h2mat,
         number_color = "black",
         treeheight_row = 0, 
         treeheight_col = 0, 
         cluster_rows = F, 
         cluster_cols = F,
         color = col,
         angle_col = 45,
         labels_row = colnames(h2mat),
         labels_col = colnames(h2mat),
         border_color = "white",
         fontsize_number = 6,
         fontsize_row = 7,
         fontsize_col = 7,
         width = 30,
         height = 30,
         na_col = 'white',
         cellheight=23,cellwidth=23
)

# grid.text('Genetic correlation', x = 0.45, y = 0.82,
#           gp=gpar(fontsize=12, col="black"),
#           just = "centre", hjust = NULL, vjust = NULL, rot = 0,
#           check.overlap = FALSE, default.units = "npc",
#           name = NULL, draw = TRUE, vp = NULL
# )

grid.text('Phenotype correlation', x = 0.45, y = 0.82,
          gp=gpar(fontsize=12, col="black"),
          just = "centre", hjust = NULL, vjust = NULL, rot = 0,
          check.overlap = FALSE, default.units = "npc",
          name = NULL, draw = TRUE, vp = NULL
)

# grid.text('Phenotype correlation', x = 0.05, y = 0.5,
#           gp=gpar(fontsize=12, col="black"),
#           just = "centre", hjust = NULL, vjust = NULL, rot = 90,
#           check.overlap = FALSE, 
#           name = NULL, draw = TRUE, vp = NULL
# )


dev.off()


# 
# 
# grid.text("SOMETHING NICE AND BIG", x=x, y=y, rot=rot,
#           gp=gpar(fontsize=20, col="grey"))
# grid.text("SOMETHING NICE AND BIG", x=x, y=y, rot=rot,
#           gp=gpar(fontsize=20), check=TRUE)
# 
# grid.newpage()
# draw.text <- function(just, i, j) {
#   grid.text("ABCD", x=x[j], y=y[i], just=just)
#   grid.text(deparse(substitute(just)), x=x[j], y=y[i] + unit(2, "lines"),
#             gp=gpar(col="grey", fontsize=8))
# }
# x <- unit(1:4/5, "npc")
# y <- unit(1:4/5, "npc")
# grid.grill(h=y, v=x, gp=gpar(col="grey"))
# draw.text(c("bottom"), 1, 1)
# draw.text(c("left", "bottom"), 2, 1)
# draw.text(c("right", "bottom"), 3, 1)
# draw.text(c("centre", "bottom"), 4, 1)
# draw.text(c("centre"), 1, 2)
# draw.text(c("left", "centre"), 2, 2)
# draw.text(c("right", "centre"), 3, 2)
# draw.text(c("centre", "centre"), 4, 2)
# draw.text(c("top"), 1, 3)
# draw.text(c("left", "top"), 2, 3)
# draw.text(c("right", "top"), 3, 3)
# draw.text(c("centre", "top"), 4, 3)
# draw.text(c(), 1, 4)
# draw.text(c("left"), 2, 4)
# draw.text(c("right"), 3, 4)
# draw.text(c("centre"), 4, 4)
# # }
# 
