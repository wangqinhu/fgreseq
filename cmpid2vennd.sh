# 1x
awk '$1~"12?3?4?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "area1 = " sum ","}'
awk '$1~"1?23?4?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "area2 = " sum ","}'
awk '$1~"1?2?34?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "area3 = " sum ","}'
awk '$1~"1?2?3?45?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "area4 = " sum ","}'
awk '$1~"1?2?3?4?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "area5 = " sum ","}'
# 2x
#1
awk '$1~"123?4?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n12 = " sum ","}'
awk '$1~"12?34?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n13 = " sum ","}'
awk '$1~"12?3?45?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n14 = " sum ","}'
awk '$1~"12?3?4?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n15 = " sum ","}'
#2
awk '$1~"1?234?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n23 = " sum ","}'
awk '$1~"1?23?45?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n24 = " sum ","}'
awk '$1~"1?23?4?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n25 = " sum ","}'
#3
awk '$1~"1?2?345?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n34 = " sum ","}'
awk '$1~"1?2?34?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n35 = " sum ","}'
#4
awk '$1~"1?2?3?45"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n45 = " sum ","}'
# 3x
#12
awk '$1~"1234?5?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n123 = " sum ","}'
awk '$1~"123?45?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n124 = " sum ","}'
awk '$1~"123?4?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n125 = " sum ","}'
#13
awk '$1~"12?345?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n134 = " sum ","}'
awk '$1~"12?34?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n135 = " sum ","}'
#14
awk '$1~"12?3?45"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n145 = " sum ","}'
#23
awk '$1~"1?2345?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n234 = " sum ","}'
awk '$1~"1?234?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n235 = " sum ","}'
#24
awk '$1~"1?23?45"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n245 = " sum ","}'
#34
awk '$1~"1?2?345"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n345 = " sum ","}'
# 4x
#1
awk '$1~"12345?"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n1234 = " sum ","}'
awk '$1~"1234?5"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n1235 = " sum ","}'
awk '$1~"123?45"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n1245 = " sum ","}'
awk '$1~"12?345"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n1345 = " sum ","}'
#2
awk '$1~"1?2345"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n2345 = " sum ","}'
# 5x
awk '$1~"12345"{print $2}' data/venn_var/cmpid.txt | awk '{sum+=$1}END{print "n12345 = " sum ","}'