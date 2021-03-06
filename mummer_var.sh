#!/bin/bash

# order contigs
abacas.1.3.1.pl -r data/refseq/merged.one.fa -q data/wgs/FG1.fa -p nucmer -m -o data/wgs/FG1o
abacas.1.3.1.pl -r data/refseq/merged.one.fa -q data/wgs/FG2.fa -p nucmer -m -o data/wgs/FG2o

# alignment
nucmer --prefix=FG1 data/refseq/FG.RR.27.genome.fa data/wgs/FG1o.MULTIFASTA.fa
nucmer --prefix=FG2 data/refseq/FG.RR.27.genome.fa data/wgs/FG2o.MULTIFASTA.fa

mv *.delta data/wgs/

# call var
show-snps -T data/wgs/FG1.delta > data/wgs/FG1.snps
show-snps -T data/wgs/FG2.delta > data/wgs/FG2.snps

# covert to vcf

# vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa data/wgs/FG1.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }' > data/wgs/FG1.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa data/wgs/FG2.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }' > data/wgs/FG2.vcf

# snps
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t SNP data/wgs/FG1.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }' > data/wgs/FG1.snps.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t SNP data/wgs/FG2.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }' > data/wgs/FG2.snps.vcf

# indels
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t INDEL data/wgs/FG1.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }' > data/wgs/FG1.indels.vcf
./mummer2Vcf.pl -f data/refseq/FG.RR.27.genome.fa -t INDEL data/wgs/FG2.snps | awk '{print $1 "\t" $2 "\t.\t" $3 "\t" $4 "\t.\t.\t" $5 }'> data/wgs/FG2.indels.vcf
