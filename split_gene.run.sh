#!/bin/bash

./extgene.interval.pl

# No variation detected in HG970330, assign the four genes into slow genome
HG970330=("FGRRES_14024" "FGRRES_14025" "FGRRES_14026" "FGRRES_20410")
for gene in ${HG970330[@]}; do
	echo $gene >> data/2speed/list.slow
done

wc -l data/2speed/list.*
