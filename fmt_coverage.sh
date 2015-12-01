#!/bin/bash

hst=("H3K27me3" "H3K36me3" "H3K4me2" "H3K4me3" "PH1_CM" "PH1_6d") 
for id in ${hst[@]}; do
	cut -f1,2,3,4 data/coverage/$id.coverage.tsv | awk '{print "Chr" $0}' > data/coverage/$id.txt
done
