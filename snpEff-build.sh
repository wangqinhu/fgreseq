#!/bin/bash

#$ -cwd
#$ -N snpEff-build
#$ -j y

appdir="/home/wangqinhu/sf/snpEff"
snpeff="java -jar $appdir/snpEff.jar"
config="/share/nas1/wangqinhu/F.graminearum/snpEff.config"

# Build database
$snpeff  build -gff3 -v FG.RR.27 -c $config
