#!/bin/sh

# convert vcf to svf (simple vcf file)
./ext.svf.sh

# combine svf
./merge_svf.pl data/svf/YL-1.svf data/svf/HN9-1.svf > data/svf/12.svf
./merge_svf.pl data/svf/12.svf data/svf/HN-Z6.svf > data/svf/123.svf
./merge_svf.pl data/svf/123.svf data/svf/GZ3639.svf > data/svf/1234.svf
./merge_svf.pl data/svf/1234.svf data/svf/CS3005.svf > data/svf/12345.svf
./merge_svf.pl data/svf/12345.svf data/svf/FG1.svf > data/svf/123456.svf
./merge_svf.pl data/svf/123456.svf data/svf/FG2.svf > data/svf/fg.snp7.svf

# convert svf to fasta sequence
./svf2seq.pl data/svf/fg.snp7.svf > data/tree/fg.snp7.fa
./fa2phy.pl data/tree/fg.snp7.fa data/tree/fg.snp7.phy

# build ml tree
phyml -i data/tree/fg.snp7.phy
