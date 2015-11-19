#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N filter_vcf
#$ -j y

reseq=("GZ3639" "HN9-1" "HN-Z6" "YL-1" "CS3005")

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

# Covert vcf files to density files
perl ./select_homo.pl data/vcf/$id.vcf > data/vcf_filtered/$id.vcf
perl ./select_homo.pl data/vcf/$id.snps.vcf > data/vcf_filtered/$id.snps.vcf
perl ./select_homo.pl data/vcf/$id.indels.vcf > data/vcf_filtered/$id.indels.vcf


