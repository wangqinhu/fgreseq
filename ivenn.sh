cd data/vcf_filtered/snps
grep -v -e "^#" CS3005.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > CS3005.txt
grep -v -e "^#" FG1.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > FG1.txt
grep -v -e "^#" FG2.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > FG2.txt
grep -v -e "^#" YL-1.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > YL-1.txt
grep -v -e "^#" HN9-1.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > HN9-1.txt
grep -v -e "^#" HN-Z6.snps.vcf | awk '{print $1 $2 $4 $5}' | sed 's/,//g' > HN-Z6.txt
cd ../../../

