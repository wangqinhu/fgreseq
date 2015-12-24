#!/bin/bash

dat=("data/cazy/CAZY.woGT.txt" "data/blast/phi.hit.tsv" "data/blast/paid.hit.tsv" "data/blast/smid.hit.tsv" "data/secretome/fg.secretome.txt")

for f in  ${dat[@]}; do
	isc data/2speed/list.fast $f | wc -l | xargs echo "fast $f: "
	isc data/2speed/list.slow $f | wc -l | xargs echo "slow $f: "
done

for f in  ${dat[@]}; do
	isc data/rnaseq/up.fast.id $f | wc -l | xargs echo "fast $f: "
	isc data/rnaseq/up.slow.id $f | wc -l | xargs echo "slow $f: "
done

for f in  ${dat[@]}; do
	isc data/pnps/positive1.fast $f | wc -l | xargs echo "fast $f: "
	isc data/pnps/positive1.slow $f | wc -l | xargs echo "slow $f: "
done
