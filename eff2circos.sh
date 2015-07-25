#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N eff2circos
#$ -j y

mkdir -p data/density/$1

names=("HN9-1" "HN-Z6" "YL-1" "GJ33" "FJ1-38")

id=${names[$(expr $SGE_TASK_ID - 1)]}

# Covert high.ann.vcf files to density files
grep "HIGH" data/eff/$id.ann.vcf > data/eff/$id.high.vcf
perl ./vcf2density.pl data/eff/$id.high.vcf data/density/$1/$id.high.density.txt $1

