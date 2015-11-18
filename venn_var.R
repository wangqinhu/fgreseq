library("VennDiagram")
# Reference five-set diagram
venn.plot <- draw.quintuple.venn(
area1 = 102038,
area2 = 74621,
area3 = 75218,
area4 = 10304,
area5 = 99082,
n12 = 33282,
n13 = 34670,
n14 = 4404,
n15 = 44076,
n23 = 32805,
n24 = 4097,
n25 = 32409,
n34 = 4617,
n35 = 34381,
n45 = 4298,
n123 = 20379,
n124 = 2561,
n125 = 21804,
n134 = 2997,
n135 = 23583,
n145 = 3080,
n234 = 2642,
n235 = 19902,
n245 = 2451,
n345 = 2808,
n1234 = 1976,
n1235 = 15076,
n1245 = 1988,
n1345 = 2289,
n2345 = 1841,
n12345 = 1611,
  category = c("YL-1", "HN9-1", "HN-Z6", "GZ3639", "CS3005"),
  fill = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  cat.col = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  #cat.cex = 1,
  margin = 0.05,
  cex = c(1, 1, 1, 1, 1, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 
          1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 1, 1),
  ind = TRUE,
  col="white",
  cat.fontfamily="ArialMT",
  fontfamily="ArialMT"
);

# Writing to file
pdf("data/venn_var/venn.pdf",6.5,6.5)
grid.draw(venn.plot)
dev.off()
