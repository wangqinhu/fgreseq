#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N Fg.reseq
#$ -j y

mkdir -p data/sam
mkdir -p data/bam
mkdir -p data/vcf

reseq=("HN9-1" "HN-Z6" "YL-1" "GJ33" "FJ1-38")

dir=${reseq[$(expr $SGE_TASK_ID - 1)]}

if [ -d data/reseq/$dir ]; then

	# Mapping
	bowtie2 -x data/refseq/FG.RR.27.genome -1 data/reseq/$dir/cleandata_500_1.fq.gz -2 data/reseq/$dir/cleandata_500_2.fq.gz -S data/sam/$dir.sam

	# Covert to bam
	samtools view -bS data/sam/$dir.sam > data/bam/$dir.bam

	# Sort bam
	samtools sort data/bam/$dir.bam data/bam/$dir.sorted

	# Call var
	samtools mpileup -uf data/refseq/FG.RR.27.genome.fa data/bam/$dir.sorted.bam | bcftools call -cv -O v - > data/vcf/$dir.vcf

	# Call snp
	samtools mpileup -uf data/refseq/FG.RR.27.genome.fa data/bam/$dir.sorted.bam | bcftools call -cv -V indels -O v - > data/vcf/$dir.snps.vcf

	# Call indel
	samtools mpileup -uf data/refseq/FG.RR.27.genome.fa data/bam/$dir.sorted.bam | bcftools call -cv -V snps -O v - > data/vcf/$dir.indels.vcf

fi
