#!/bin/bash

#$ -cwd
#$ -N tree
#$ -j y

mkdir -p data/tree

/home/wangqinhu/sf/snphylo/snphylo.sh -v data/vcf/YL-1.snps.vcf data/vcf/HN9-1.snps.vcf data/vcf/HN-Z6.snps.vcf data/vcf/GJ33.snps.vcf data/vcf/FJ1-38.snps.vcf -b 


