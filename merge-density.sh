#!/bin/bash

# density_directory
dd="./data/density"
paste <(cut -f1,2,3 $dd/YL-1.density.txt) <(paste <(cut -f4 $dd/YL-1.density.txt) <(cut -f4 $dd/HN9-1.density.txt) <(cut -f4 $dd/HN-Z6.density.txt) <(cut -f4 $dd/CS3005.density.txt) | awk '{print ($1+$2+$3+$4)/4}') > $dd/density.txt
paste <(cut -f1,2,3 $dd/YL-1.density.txt) <(paste <(cut -f4 $dd/YL-1.density.txt) <(cut -f4 $dd/HN9-1.density.txt) <(cut -f4 $dd/HN-Z6.density.txt) <(cut -f4 $dd/CS3005.density.txt) <(cut -f4 $dd/FG1.density.txt) <(cut -f4 $dd/FG2.density.txt) | awk '{print ($1+$2+$3+$4+$5+$6)/6}') > $dd/density6.txt
