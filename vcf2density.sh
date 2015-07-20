#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N vcf2density
#$ -j y

# usage
# qsub *.sh window_size

mkdir -p data/density/$1

reseq=("HN9-1" "HN-Z6" "YL-1" "GJ33" "FJ1-38")

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

# Covert vcf files to density files
perl ./vcf2density.pl data/eff/$id.ann.vcf data/density/$1/$id.density.txt $1

