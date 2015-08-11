#!/bin/bash

#$ -t 1-10
#$ -cwd
#$ -N blast
#$ -j y

blastp="/share/nas2/genome/biosoft/blast/2.2.28/bin/blastp"
data=("0" "1500" "3000" "4500" "6000" "7500" "9000" "10500" "12000" "13500")

id=${data[$(expr $SGE_TASK_ID - 1)]}

if [ -e fasta/FG.RR.27.$id.fa ]; then
	$blastp -db /share/nas2/db/ncbi/nr -outfmt 5 -evalue 1e-3 -word_size 3 -show_gis -num_alignments 20 -max_hsps_per_subject 20 -num_threads 14 -out xml/blast.$id.xml -query fasta/FG.RR.27.$id.fa
fi
