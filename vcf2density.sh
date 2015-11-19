#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N vcf2density
#$ -j y

# usage
# qsub *.sh window_size

mkdir -p data/density/$1

reseq=("HN9-1" "HN-Z6" "YL-1" "CS3005" "GZ3639")

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

# Covert vcf files to density files
perl ./vcf2density.pl data/vcf_filtered/$id.vcf data/density/$id.density.txt $1
