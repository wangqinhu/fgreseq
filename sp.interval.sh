#!/bin/bash

paste <(cat data/2speed/state.tsv) <(head -1520 data/secretome/sp.interval.tsv | cut -f 4) > data/secretome/sp.state.txt
grep " 1\t" data/secretome/sp.state.txt | cut -f 2 > data/secretome/sp.fast.interval.txt
grep " 2\t" data/secretome/sp.state.txt | cut -f 2 > data/secretome/sp.slow.interval.txt
