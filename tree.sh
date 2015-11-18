#!/bin/sh

# convert vcf to svf (simple vcf file)
./ext.svf.sh

# combine svf
./merge_svf.pl data/svf/YL-1.svf data/svf/HN9-1.svf > data/svf/12.svf
./merge_svf.pl data/svf/12.svf data/svf/HN-Z6.svf > data/svf/123.svf
./merge_svf.pl data/svf/123.svf data/svf/GZ3639.svf > data/svf/1234.svf
./merge_svf.pl data/svf/1234.svf data/svf/CS3005.svf > data/svf/fg.snp5.svf

# convert svf to fasta sequence
./svf2seq.pl data/svf/fg.snp5.svf > data/tree/fg.snp5.fa
./fa2phy.pl data/tree/fg.snp5.fa data/tree/fg.snp5.phy

# build ml tree
phyml -i data/tree/fg.snp5.phy
