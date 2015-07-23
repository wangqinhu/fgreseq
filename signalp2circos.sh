#!/bin/bash

#$ -cwd
#$ -N signalp2circos
#$ -j y

mkdir -p data/signalp

perl ./signalp2circos.pl data/refseq/FG.RR.27.pep.all.fa data/signalp/signalp.txt data/refseq/FG.RR.27.gff3

