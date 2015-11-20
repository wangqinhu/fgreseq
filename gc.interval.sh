#!/bin/bash

paste <(cat data/2speed/state.tsv) <(head -1520 data/gc/gc.interval.tsv | cut -f 4) > data/gc/gc.state.txt
grep " 1\t" data/gc/gc.state.txt | cut -f 2 > data/gc/gc.fast.txt
grep " 2\t" data/gc/gc.state.txt | cut -f 2 > data/gc/gc.slow.txt