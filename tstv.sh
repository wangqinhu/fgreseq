bcftools filter -i'%QUAL>20' 1.vcf | bcftools stats | grep TSTV
