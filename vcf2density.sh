#!/bin/bash

mkdir -p data/density

cp data/wgs/*.vcf data/vcf_filtered/

strains=("HN9-1" "HN-Z6" "YL-1" "CS3005" "GZ3639" "FG1" "FG2")

# Covert vcf files to density files
for strain in  ${strains[@]}; do
	perl ./vcf2density.pl data/vcf_filtered/$strain.vcf data/density/$strain.density.txt
done
