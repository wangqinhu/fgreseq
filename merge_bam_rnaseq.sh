#!/bin/bash

#$ -cwd
#$ -N merge.bam.rnaseq
#$ -j y

db="../F.graminearum/data/rnaseq/bam"

samtools merge -r $db/PH1_6d.merged.bam $db/PH1_6d_1.sorted.bam $db/PH1_6d_2.sorted.bam
samtools merge -r $db/PH1_CM.merged.bam $db/PH1_CM_1.sorted.bam $db/PH1_CM_2.sorted.bam
