#!/bin/bash

#$ -t 1-2
#$ -cwd
#$ -N gene2density
#$ -j y

# usage
# qsub *.sh window_size

mkdir -p data/density/$1

files=("signalp" "transcripts")

id=${files[$(expr $SGE_TASK_ID - 1)]}

# Covert gene location files to density files
perl ./gene2density.pl data/circos/$id.txt data/density/$1/$id.density.txt $1

