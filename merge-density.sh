#!/bin/bash

#$ -cwd
#$ -N merge_density
#$ -j y

# Sum density files
cd data/density/25000
paste <(cut -f1,2,3 YL-1.density.txt) <(paste <(cut -f4 YL-1.density.txt) <(cut -f4 HN9-1.density.txt) <(cut -f4 HN-Z6.density.txt) <(cut -f4 GJ33.density.txt) <(cut -f4 FJ1-38.density.txt) | awk '{print $1+$2+$3+$4+$5}') >.density.txt
