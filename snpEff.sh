#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N Fg.snpEff
#$ -j y

mkdir -p data/eff
mkdir -p data/html
mkdir -p data/csv

config="/share/nas1/wangqinhu/F.graminearum/snpEff.config"
snpeff="java -jar /home/wangqinhu/sf/snpEff/snpEff.jar"
reseq=("HN9-1" "HN-Z6" "YL-1" "GJ33" "FJ1-38")
ref="FG.RR.27"

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

if [ -e data/vcf/$id.vcf ]; then

	$snpeff ann -v -c $config -s data/html/$id.html $ref data/vcf/$id.vcf > data/eff/$id.ann.vcf

fi
