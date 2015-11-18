#!/bin/bash

strains=("HN9-1" "HN-Z6" "YL-1" "CS3005")
terms=("start_lost" "stop_gained" "frameshift" "stop_lost")
terms2=("start_lost" "stop_gained" "frameshift")

mkdir -p data/venn_lof/high
mkdir -p data/venn_lof/id
mkdir -p data/venn_lof/lof

# extract var. have high effect
for strain in  ${strains[@]}; do
	for term in  ${terms[@]}; do
		grep $term data/eff/$strain.ann.vcf > data/venn_lof/high/$strain.$term.txt
		cat data/venn_lof/high/$strain.$term.txt | wc -l | xargs echo "var:  $strain  $term  "
	done
done

# extract highly effected genes
for strain in  ${strains[@]}; do
	for term in  ${terms2[@]}; do
		perl ./exhg.pl data/venn_lof/high/$strain.$term.txt > data/venn_lof/id/$strain.$term.id
		cat data/venn_lof/id/$strain.$term.id | cut -f 5 | sort | uniq > data/venn_lof/id/$strain.$term.nr.id
	done
	cat data/venn_lof/id/$strain.*.nr.id | sort | uniq  > data/venn_lof/id/$strain.lof.id
done


# 1. CS3005
# 2. HN-Z6
# 3. HN9-1
# 4. YL-1

cp data/venn_lof/id/CS3005.lof.id data/venn_lof/lof/1.id
cp data/venn_lof/id/HN-Z6.lof.id data/venn_lof/lof/2.id
cp data/venn_lof/id/HN9-1.lof.id data/venn_lof/lof/3.id
cp data/venn_lof/id/YL-1.lof.id data/venn_lof/lof/4.id

cat data/venn_lof/lof/*.id | sort | uniq | wc -l | xargs echo "total lof genes: "

cat <<'RSCRIPT' > venn_lof.R 
library("VennDiagram")
# Reference four-set diagram
venn.plot <- draw.quad.venn(
RSCRIPT

sh lofid2vennd.sh >> venn_lof.R 

cat <<'RSCRIPT' >> venn_lof.R 
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
RSCRIPT

R CMD BATCH ./venn_lof.R
