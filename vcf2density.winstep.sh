#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N vcf2density.winstep
#$ -j y

# usage
# qsub *.sh window_size

mkdir -p data/density/$1

reseq=("HN9-1" "HN-Z6" "YL-1" "GJ33" "FJ1-38")

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

# Covert vcf files to density files
perl ./vcf2density.winstep.pl data/vcf/$id.vcf data/density/$1/$id.density.winstep.txt $1

