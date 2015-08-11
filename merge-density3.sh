#!/bin/bash

#$ -cwd
#$ -N merge_density.winstep3
#$ -j y

# Sum eff.density.winstep files
cd data/density.winstep/25000
paste <(cut -f1,2,3 YL-1.density.winstep.txt) <(paste <(cut -f4 YL-1.density.winstep.txt) <(cut -f4 HN9-1.density.winstep.txt) <(cut -f4 HN-Z6.density.winstep.txt) | awk '{print $1+$2+$3}') > density.winstep.txt
