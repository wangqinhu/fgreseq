#!/bin/bash

#$ -cwd
#$ -N secretome2circos
#$ -j y

perl ./secretome2circos.pl data/secretome/fg.secretome.txt data/refseq/FG.RR.27.gff3 data/circos/data/secretome.txt
perl ./gene2density.pl data/circos/data/secretome.txt data/circos/data/secretome.density.txt $1
cp data/circos/data/secretome.density.txt data/secretome/sp.interval.tsv
