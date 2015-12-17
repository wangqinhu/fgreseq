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

# call ivenn next
