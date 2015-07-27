awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%1500==0){file=sprintf("FG.RR.27.%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < FG.RR.27.pep.all.fa
