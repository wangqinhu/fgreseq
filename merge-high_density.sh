#!/bin/bash

#$ -cwd
#$ -N merge-high_density
#$ -j y

# Sum eff.high.density files
cd data/density/25000
paste <(cut -f1,2,3 YL-1.high.density.txt) <(paste <(cut -f4 YL-1.high.density.txt) <(cut -f4 HN9-1.high.density.txt) <(cut -f4 HN-Z6.high.density.txt) <(cut -f4 GJ33.high.density.txt) <(cut -f4 FJ1-38.high.density.txt) | awk '{print $1+$2+$3+$4+$5}') > high.density.txt
