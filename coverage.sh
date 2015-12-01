#!/bin/bash

#$ -t 1-4
#$ -cwd
#$ -N coverage
#$ -j y

mkdir -p data/coverage

db="data/bam"

hst=("H3K27me3" "H3K36me3" "H3K4me2" "H3K4me3")

id=${hst[$(expr $SGE_TASK_ID - 1)]}

if [ -e $db/$id.merged.bam ]; then

	bedtools coverage -a data/bed/interval.bed -b $db/$id.merged.bam > data/coverage/$id.coverage.tsv
	
fi
