#!/bin/sh

makeblastdb -in data/blast/database/smid.fa -dbtype prot

#./fmtseq.pl data/refseq/Fusarium_graminearum.RR.27.pep.all.fa data/refseq/fg.pep.fa

blastp -query data/refseq/fg.pep.fa -db data/blast/database/smid.fa -evalue 1e-50 -num_descriptions 10 -num_alignments 10 -out data/blast/smid.txt

./parse_blast.pl data/blast/smid.txt data/blast/smid.hit.tsv
