#!/bin/bash

strains=("HN9-1" "HN-Z6" "YL-1" "CS3005" "FG1" "FG2")
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
	cat data/venn_lof/id/$strain.*.nr.id | sort | uniq  > data/venn_lof/lof/$strain.lof.id
done
