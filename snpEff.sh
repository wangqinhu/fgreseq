#!/bin/bash

#$ -t 1-5
#$ -cwd
#$ -N Fg.snpEff
#$ -j y

mkdir -p data/eff
mkdir -p data/html

config="/share/nas1/wangqinhu/F.graminearum/snpEff.config"
snpeff="java -jar /home/wangqinhu/sf/snpEff/snpEff.jar"
reseq=("GZ3639" "HN9-1" "HN-Z6" "YL-1" "CS3005")
ref="FG.RR.27.1"

id=${reseq[$(expr $SGE_TASK_ID - 1)]}

if [ -e data/vcf_filtered/$id.vcf ]; then

	$snpeff ann -v -c $config -ud 500 -s data/html/$id.html $ref data/vcf/$id.vcf > data/eff/$id.ann.vcf

fi
