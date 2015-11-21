#!/bin/bash

mkdir -p data/pnps/cds
mkdir -p data/pnps/tsv

# Handle PH-1
./gff2fasta.pl -gff data/refseq/genes.gff -fasta data/refseq/FG.RR.27.genome.fa -feature CDS -seq-desc Parent -wrap 0 -length 0 -out data/pnps/cds/cds.PH-1.txt
./combcds.pl data/pnps/cds/cds.PH-1.txt > data/pnps/tsv/PH-1.seq.tsv

# Handle reseq strains
strains=("HN9-1" "HN-Z6" "YL-1" "CS3005")

for id in  ${strains[@]}; do

	# covert vcf to fasta
	./vcf2fasta.pl -vcf data/vcf_filtered/$id.snps.vcf -gff data/refseq/genes.gff -fasta data/refseq/FG.RR.27.genome.fa -feature CDS -seq-desc Parent -wrap 0 -length 0 -out data/pnps/cds/cds.$id.txt
	# combine cds and convert to sequence table
	./combcds.pl data/pnps/cds/cds.$id.txt > data/pnps/tsv/$id.seq.tsv

done

# selection analysis
./pnps.pl > data/pnps/pnps.tsv
