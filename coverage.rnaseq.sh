#!/bin/bash

#$ -t 1-2
#$ -cwd
#$ -N coverage.rnaseq
#$ -j y

mkdir -p data/coverage

db="../F.graminearum/data/rnaseq/bam"

hst=("PH1_6d" "PH1_CM")

id=${hst[$(expr $SGE_TASK_ID - 1)]}

if [ -e $db/$id.merged.bam ]; then

	bedtools coverage -a data/bed/interval.bed -b $db/$id.merged.bam > data/coverage/$id.coverage.tsv
	
fi
