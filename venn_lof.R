library("VennDiagram")
# Reference four-set diagram
venn.plot <- draw.quad.venn(
area1 =  463,
area2 =  42,
area3 =  390,
area4 =  561,
n12 =  18,
n13 =  155,
n14 =  216,
n23 =  21,
n24 =  21,
n34 =  178,
n123 =  12,
n124 =  16,
n134 =  108,
n234 =  15,
n1234 =  12,
  category = c("CS3005", "HN-Z6", "HN9-1","YL-1"),
  fill = c("orange", "red", "green", "blue"),
  lty = 1,
  col="white",
  cex = 1.1,
  cat.cex = 1.1,
  cat.col = c("orange", "red", "green", "blue"),
  cat.fontfamily="ArialMT",
  fontfamily="ArialMT"
);

# Writing to file
pdf("data/venn_lof/venn.pdf",5,5)
grid.draw(venn.plot)
dev.off()
