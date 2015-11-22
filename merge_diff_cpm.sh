#!/bin/sh

echo "\011\c" > data/rnaseq/rnaseq.sum.tsv
paste data/rnaseq/rnaseq.diff.tsv data/rnaseq/rnaseq.cpm.tsv >> data/rnaseq/rnaseq.sum.tsv

