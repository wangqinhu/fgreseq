#!/bin/bash

#$ -cwd
#$ -N venn
#$ -j y

mkdir -p data/venn

cd data/gz

# cp vcf --> gz
# bgzip vcf
# tabix -p vcf 1.vcf

#bcftools stats -1 YL-1.vcf.gz HN9-1.vcf.gz > ../venn/file.vchk
vcf-compare *.vcf.gz

#cd ../venn
#plot-vcfstats file.vchk -p plots/
