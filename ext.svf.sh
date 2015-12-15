grep '^[^#]' data/vcf_filtered/GZ3639.snps.vcf | cut -f1,2,4,5 > data/svf/GZ3639.svf
grep '^[^#]' data/vcf_filtered/YL-1.snps.vcf | cut -f1,2,4,5 > data/svf/YL-1.svf
grep '^[^#]' data/vcf_filtered/HN9-1.snps.vcf | cut -f1,2,4,5 > data/svf/HN9-1.svf
grep '^[^#]' data/vcf_filtered/HN-Z6.snps.vcf | cut -f1,2,4,5 > data/svf/HN-Z6.svf
grep '^[^#]' data/vcf_filtered/CS3005.snps.vcf | cut -f1,2,4,5 > data/svf/CS3005.svf
grep '^[^#]' data/wgs/FG1.snps.vcf | cut -f1,2,4,5 > data/svf/FG1.svf
grep '^[^#]' data/wgs/FG2.snps.vcf | cut -f1,2,4,5 > data/svf/FG2.svf

