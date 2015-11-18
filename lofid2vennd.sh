lof_dir="data/venn_lof/lof/"
cat $lof_dir/1.id | wc -l | xargs echo -n "area1 = " && echo ","
cat $lof_dir/2.id | wc -l | xargs echo -n "area2 = " && echo ","
cat $lof_dir/3.id | wc -l | xargs echo -n "area3 = " && echo ","
cat $lof_dir/4.id | wc -l | xargs echo -n "area4 = " && echo ","
./isc $lof_dir/1.id $lof_dir/2.id > $lof_dir/12.id && cat $lof_dir/12.id | wc -l |xargs echo -n "n12 = " && echo ","
./isc $lof_dir/1.id $lof_dir/3.id > $lof_dir/13.id && cat $lof_dir/13.id | wc -l |xargs echo -n "n13 = " && echo ","
./isc $lof_dir/1.id $lof_dir/4.id > $lof_dir/14.id && cat $lof_dir/14.id | wc -l |xargs echo -n "n14 = " && echo ","
./isc $lof_dir/2.id $lof_dir/3.id > $lof_dir/23.id && cat $lof_dir/23.id | wc -l |xargs echo -n "n23 = " && echo ","
./isc $lof_dir/2.id $lof_dir/4.id > $lof_dir/24.id && cat $lof_dir/24.id | wc -l |xargs echo -n "n24 = " && echo ","
./isc $lof_dir/3.id $lof_dir/4.id > $lof_dir/34.id && cat $lof_dir/34.id | wc -l |xargs echo -n "n34 = " && echo ","
./isc $lof_dir/12.id $lof_dir/3.id > $lof_dir/123.id && cat $lof_dir/123.id | wc -l | xargs echo -n "n123 = " && echo ","
./isc $lof_dir/12.id $lof_dir/4.id > $lof_dir/124.id && cat $lof_dir/124.id | wc -l |xargs echo -n "n124 = " && echo ","
./isc $lof_dir/13.id $lof_dir/4.id > $lof_dir/134.id && cat $lof_dir/134.id | wc -l |xargs echo -n "n134 = " && echo ","
./isc $lof_dir/23.id $lof_dir/4.id > $lof_dir/234.id && cat $lof_dir/234.id | wc -l |xargs echo -n "n234 = " && echo ","
./isc $lof_dir/12.id $lof_dir/34.id > $lof_dir/1234.id && cat $lof_dir/1234.id | wc -l |xargs echo -n "n1234 = " && echo ","