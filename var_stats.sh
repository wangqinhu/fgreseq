#!/bin/bash

strains=("HN9-1" "HN-Z6" "YL-1" "CS3005")

# extract var. have high effect
for strain in  ${strains[@]}; do
	bcftools stats data/vcf_filtered/$strain.vcf | grep "^SN" | grep "records" | cut -f 4 | xargs echo "$strain total ";
	bcftools stats data/vcf_filtered/$strain.snps.vcf | grep "^SN" | grep "records" | cut -f 4 | xargs echo "$strain SNP ";
	bcftools stats data/vcf_filtered/$strain.indels.vcf | grep "^SN" | grep "records" | cut -f 4 | xargs echo "$strain INDEL ";
done
