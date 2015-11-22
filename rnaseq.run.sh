#!/bin/bash

# mapping
#./hisat-build.sh
#./hisat.sh

# count reads
#./featurecounts.sh

echo -e "\tMycelia.1\tMycelia.2\tInfection.1\tInfection.2" > data/rnaseq/rnaseq.raw.tsv
grep "^FGRRES_\d" data/rnaseq/rnaseq.fc | awk '{ print $1 "\t" $9 "\t" $10 "\t" $7 "\t" $8 }' >> data/rnaseq/rnaseq.raw.tsv
