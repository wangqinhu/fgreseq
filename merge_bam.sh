#!/bin/bash

#$ -cwd
#$ -N merge.bam
#$ -j y

db="data/bam"

samtools merge -r $db/H3K27me3.merged.bam $db/H3K27me3.1.sorted.bam $db/H3K27me3.2.sorted.bam $db/H3K27me3.3.sorted.bam
samtools merge -r $db/H3K36me3.merged.bam $db/H3K36me3.1.sorted.bam $db/H3K36me3.2.sorted.bam
samtools merge -r $db/H3K4me2.merged.bam  $db/H3K4me2.1.sorted.bam  $db/H3K4me2.2.sorted.bam  $db/H3K4me2.3.sorted.bam  $db/H3K4me2.4.sorted.bam
samtools merge -r $db/H3K4me3.merged.bam  $db/H3K4me3.1.sorted.bam  $db/H3K4me3.2.sorted.bam
