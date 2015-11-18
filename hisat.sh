#!/bin/bash

#$ -t 1-4
#$ -cwd
#$ -N Fg.rnaseq
#$ -j y

mkdir -p data/rnaseq/sam
mkdir -p data/rnaseq/bam

rnaseq=("PH1_CM_1" "PH1_CM_2" "PH1_6d_1" "PH1_6d_2")

id=${rnaseq[$(expr $SGE_TASK_ID - 1)]}

# Mapping
hisat -x /share/nas1/wangqinhu/F.graminearum/data/refseq/hisat/FG.RR.27.genome -p 6 -1 data/rnaseq/$id.1.clean.fq.gz -2 data/rnaseq/$id.2.clean.fq.gz -S data/rnaseq/sam/$id.sam

# Covert to bam
samtools view -bS data/rnaseq/sam/$id.sam > data/rnaseq/bam/$id.bam

# Sort bam
samtools sort data/rnaseq/bam/$id.bam data/rnaseq/bam/$id.sorted

