#!/bin/bash

# order contigs
abacas.1.3.1.pl -r data/refseq/merged.one.fa -q data/wgs/FG1.fa -p nucmer -m -o data/wgs/FG1o
abacas.1.3.1.pl -r data/refseq/merged.one.fa -q data/wgs/FG2.fa -p nucmer -m -o data/wgs/FG2o

# alignment
nucmer --prefix=fg1 data/refseq/FG.RR.27.genome.fa data/wgs/FG1o.MULTIFASTA.fa
nucmer --prefix=fg2 data/refseq/FG.RR.27.genome.fa data/wgs/FG2o.MULTIFASTA.fa

mv *.delta data/wgs/

# call var
show-snps -T data/wgs/fg1.delta > data/wgs/fg1.snps
show-snps -T data/wgs/fg2.delta > data/wgs/fg2.snps

# covert to vcf

# vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa data/wgs/fg1.snps > data/wgs/fg1.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa data/wgs/fg2.snps > data/wgs/fg2.vcf

# snps
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t SNP data/wgs/fg1.snps > data/wgs/fg1.snps.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t SNP data/wgs/fg2.snps > data/wgs/fg2.snps.vcf

# indels
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t INDEL data/wgs/fg1.snps > data/wgs/fg1.indels.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t INDEL data/wgs/fg2.snps > data/wgs/fg2.indels.vcf
