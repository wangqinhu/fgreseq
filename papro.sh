#!/bin/sh

makeblastdb -in data/blast/database/paid.fa -dbtype prot

#./fmtseq.pl data/refseq/Fusarium_graminearum.RR.27.pep.all.fa data/refseq/fg.pep.fa

blastp -query data/refseq/fg.pep.fa -db data/blast/database/paid.fa -evalue 1e-50 -num_descriptions 10 -num_alignments 10 -out data/blast/paid.txt

./parse_blast.pl data/blast/paid.txt data/blast/paid.hit.tsv
