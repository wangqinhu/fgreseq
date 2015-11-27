#!/bin/sh

makeblastdb -in data/blast/database/PHI.fa -dbtype prot

./fmtseq.pl data/refseq/Fusarium_graminearum.RR.27.pep.all.fa data/refseq/fg.pep.fa

blastp -query data/refseq/fg.pep.fa -db data/blast/database/PHI.fa -evalue 1e-5 -num_descriptions 10 -num_alignments 10 -out data/blast/phi.txt

./parse_blast.pl data/blast/phi.txt data/blast/phi.hit.tsv
