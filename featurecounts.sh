#!/bin/bash

#$ -cwd
#$ -N featureCounts
#$ -j y

featureCounts -T 10 -M -p -O -t exon -g gene_id -a data/refseq/FG.RR.27.gtf -o data/rnaseq/rnaseq.fc data/rnaseq/bam/PH1_6d_1.sorted.bam data/rnaseq/bam/PH1_6d_2.sorted.bam data/rnaseq/bam/PH1_CM_1.sorted.bam data/rnaseq/bam/PH1_CM_2.sorted.bam
