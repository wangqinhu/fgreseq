#!/bin/sh

# fg
./extfir.pl data/refseq/FG.RR.27.gff3 > data/2speed/fg.fir.tsv
./isc data/2speed/list.fast data/2speed/fg.fir.tsv > data/2speed/fg.fast.fir.tsv
./isc data/2speed/list.slow data/2speed/fg.fir.tsv > data/2speed/fg.slow.fir.tsv

# pi
grep "codon" data/refseq/phytophthora_infestans_t30-4_1_transcripts.gtf > data/refseq/ss.gtf
./fmtgtf.pl data/refseq/ss.gtf > data/refseq/pigene.gtf && rm data/refseq/ss.gtf
./extfir_gtf.pl data/refseq/pigene.gtf > data/2speed/pi.fir.tsv

# plot
R CMD BATCH fir.R
