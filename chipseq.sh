#!/bin/bash

#$ -t 1-11
#$ -cwd
#$ -N Fg.ChIPSeq
#$ -j y

mkdir -p data/sam
mkdir -p data/bam
mkdir -p data/fastq

chip="/share/nas1/wangqinhu/epi/data/sra/SRP030207"
sra=("SRR999608" "SRR999609" "SRR999610" "SRR999611" "SRR999612" "SRR999613" "SRR999614" "SRR999615" "SRR999616" "SRR999617" "SRR999618") 
tag=("H3K27me3.1" "H3K27me3.2" "H3K27me3.3" "H3K36me3.1" "H3K36me3.2" "H3K4me2.1" "H3K4me2.2" "H3K4me2.3" "H3K4me2.4" "H3K4me3.1" "H3K4me3.2") 

rid=${sra[$(expr $SGE_TASK_ID - 1)]}
tid=${tag[$(expr $SGE_TASK_ID - 1)]}

if [ -e $chip/$rid/$rid.sra ]; then

	# Dump fastq
	fastq-dump $chip/$rid/$rid.sra -Z > data/fastq/$tid.fastq

	# Mapping
	bowtie data/refseq/FG.RR.27.genome -q data/fastq/$tid.fastq -S --sam-RG $tid > data/sam/$tid.sam

	# Covert to bam
	samtools view -bS data/sam/$tid.sam > data/bam/$tid.bam

	# Sort bam
	samtools sort data/bam/$tid.bam data/bam/$tid.sorted

fi
