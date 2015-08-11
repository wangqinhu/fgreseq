# YL-1.vcf.gz  1
# HN9-1.vcf.gz 2
# HN-Z6.vcf.gz 3
# GJ33.vcf.gz 4
# FJ1-38.vcf.gz 5
# use the following command to capture vcf-compare out
# awk '$1~"1?2?3?4?5?"{print $2}' snp.txt  | awk '{sum+=$1}END{print sum}'

library("VennDiagram")
# Reference five-set diagram
venn.plot <- draw.quintuple.venn(
  area1 = 101817,
  area2 = 76298,
  area3 = 77035,
  area4 = 474370,
  area5 = 483806,
  n12 = 33832,
  n13 = 35001,
  n14 = 33114,
  n15 = 33556,
  n23 = 33248,
  n24 = 22846,
  n25 = 23231,
  n34 = 24252,
  n35 = 24477,
  n45 = 431583,
  n123 = 20622,
  n124 = 15193,
  n125 = 15471,
  n134 = 16251,
  n135 = 16382,
  n145 = 31181,
  n234 = 13446,
  n235 = 13652,
  n245 = 21249,
  n345 = 22729,
  n1234 = 10410,
  n1235 = 10576,
  n1245 = 14406,
  n1345 = 15432,
  n2345 = 12760,
  n12345 = 9964,
  category = c("YL-1", "HN9-1", "HN-Z6", "GJ33", "FJ1-38"),
  fill = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  cat.col = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"),
  cat.cex = 1.1,
  margin = 0.05,
  cex = c(1, 1, 1, 1, 1, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.8, 
          1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 1, 1),
  ind = TRUE
);

# Writing to file
pdf("venn.pdf",7,7);
grid.draw(venn.plot);
dev.off();