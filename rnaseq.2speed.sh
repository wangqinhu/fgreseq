#!/bin/sh

echo "\tlogFC\tlogCPM\tPValue\tFDR" > data/rnaseq/slow.diff.tsv
./isc data/2speed/list.slow data/rnaseq/rnaseq.diff.tsv >> data/rnaseq/slow.diff.tsv

echo "\tlogFC\tlogCPM\tPValue\tFDR" > data/rnaseq/fast.diff.tsv
./isc data/2speed/list.fast data/rnaseq/rnaseq.diff.tsv >> data/rnaseq/fast.diff.tsv

echo "\tlogFC\tlogCPM\tPValue\tFDR" > data/rnaseq/no.diff.tsv
./isc data/rnaseq/nondeid.txt data/rnaseq/rnaseq.diff.tsv >> data/rnaseq/no.diff.tsv

