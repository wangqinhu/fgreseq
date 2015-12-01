#!/bin/bash

#$ -cwd
#$ -N bowtie-build
#$ -j y

# Build database
bowtie-build data/refseq/FG.RR.27.genome.fa data/refseq/FG.RR.27.genome
