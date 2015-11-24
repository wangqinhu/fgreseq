#!/bin/sh

# calcualtion the gc content and length for genes
./len_gc.pl data/refseq/Fusarium_graminearum.RR.27.cds.all.fa >> data/2speed/gene.lengc.tsv

# extract the fast and slow genes
./isc data/2speed/list.fast data/2speed/gene.lengc.tsv > data/2speed/fast.lengc.tsv
./isc data/2speed/list.slow data/2speed/gene.lengc.tsv > data/2speed/slow.lengc.tsv

# exon number
./extexon.pl data/refseq/FG.RR.27.gff3 > data/2speed/exon.tsv

# extract the fast and slow genes
./isc data/2speed/list.fast data/2speed/exon.tsv > data/2speed/fast.exon.tsv
./isc data/2speed/list.slow data/2speed/exon.tsv > data/2speed/slow.exon.tsv

R CMD BATCH 2speed.supp.R
