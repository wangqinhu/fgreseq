#!/bin/bash

mkdir -p data/spe_snp

# find all specific snps
./svf2spe_vcf.pl data/svf/fg.snp7.svf > data/spe_snp/spe.tsv

# split each specific snp
strains=("PH-1" "YL-1" "HN9-1" "HN-Z6" "GZ3639" "CS3005" "FG1" "FG2")

for id in  ${strains[@]}; do

  cat data/spe_snp/spe.tsv | grep $id | cut -f2,3,4,5 > data/spe_snp/$id.vcf

done
