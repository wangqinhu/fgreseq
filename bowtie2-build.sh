#!/bin/bash

#$ -cwd
#$ -N bowtie2-build
#$ -j y

# Build database
bowtie2-build data/refseq/FG.RR.27.genome.fa data/refseq/FG.RR.27.genome
