#!/bin/bash

mkdir -p data/venn_var
mkdir -p data/vcf_filtered_gi


# YL-1 1
# HN9-1 2
# HN-Z6 3
# GZ3639 4
# CS3005 5
# use the following command to capture vcf-compare out
# awk '$1~"1?2?3?4?5?"{print $2}' snp5.txt  | awk '{sum+=$1}END{print "n12 = " sum ","}'

strains=("YL-1" "HN9-1" "HN-Z6" "GZ3639" "CS3005")


for strain in  ${strains[@]}; do
	cp data/vcf_filtered/$strain.vcf data/vcf_filtered_gi/
	bgzip data/vcf_filtered_gi/$strain.vcf
	tabix -p vcf data/vcf_filtered_gi/$strain.vcf.gz
done

vcf-compare data/vcf_filtered_gi/*.vcf.gz | grep ^VN | cut -f 2- > data/venn_var/vcf.cmp.txt

cat data/venn_var/vcf.cmp.txt | ./fmt_vcfcmp.pl - > data/venn_var/cmpid.txt

cat <<'RSCRIPT' > venn_var.R 
library("VennDiagram")
# Reference five-set diagram
venn.plot <- draw.quintuple.venn(
RSCRIPT

sh cmpid2vennd.sh >> venn_var.R

cat <<'RSCRIPT' >> venn_var.R 
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
RSCRIPT

R CMD BATCH ./venn_var.R