#!/bin/bash

#$ -cwd
#$ -N gccontent
#$ -j y

mkdir -p data/gc

perl ./gccontent.pl data/refseq/FG.RR.27/sequences.fa data/gc/gc.interval.tsv
