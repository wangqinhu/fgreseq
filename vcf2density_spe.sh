#!/bin/bash

mkdir -p data/density_spe

strains=("HN9-1" "HN-Z6" "YL-1" "CS3005" "GZ3639" "FG1" "FG2")

# Covert vcf files to density files
for strain in  ${strains[@]}; do
	perl ./vcf2density.pl data/spe_snp/$strain.vcf data/density_spe/$strain.density.txt
done
