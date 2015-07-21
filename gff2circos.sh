#!/bin/bash

#$ -cwd
#$ -N gff2circos
#$ -j y

mkdir -p data/circos/

perl ./gff2circos.pl data/refseq/FG.RR.27.gff3 data/circos/transcripts.txt

