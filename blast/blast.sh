#!/bin/bash

#$ -t 1-10
#$ -cwd
#$ -N blast
#$ -j y

data=("0" "1500" "3000" "4500" "6000" "7500" "9000" "10500" "12000" "13500")

id=${data[$(expr $SGE_TASK_ID - 1)]}

if [ -e fasta/FG.RR.27.$id.fa ]; then
	/home/wangqinhu/sf/ncbi-blast-2.2.31+/bin/blastp -db /share/nas2/db/ncbi/nr -outfmt 5 -evalue 1e-3 -word_size 3 -show_gis -num_alignments 20 -max_hsps 20 -num_threads 10 -out xml/blast.$id.xml -query fasta/FG.RR.27.$id.fa
fi
