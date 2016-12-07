library(VennDiagram)

pdf("infection.pdf", family = "ArialMT", 3.5,3.5)

#par(mar=c(4,0,4.5,5))
venn.plot <- draw.triple.venn(
  area1 = 2243,
  area2 = 1181,
  area3 = 616,
  n12 = 109,
  n23 = 47,
  n13 = 221,
  n123 = 8,
  category = c("Up", "Positive", "SP"),
  fill =  c("#FFCC66", "#EE6666", "#66FF99"),
  lty = 1,
  col="white",
  cex = 1,
  cat.cex = 1,
  cat.fontfamily="ArialMT",
  fontfamily="ArialMT",
  cat.col = c("#FFCC66", "#EE6666", "#66FF99")
)
grid.draw(venn.plot)
dev.off()