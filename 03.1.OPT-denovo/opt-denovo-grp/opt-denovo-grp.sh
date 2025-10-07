#!/bin/bash
for M in 1 2 3 4 5 6 7 8 9 10; 
do
    for n in 1 2 3 4 5 6 7 8 9 10;
    do
        out=denovo-GRP.M${M}.n${n};
        echo $out;
        mkdir -p $out;
        denovo_map.pl --samples ../02_filtered-adaptor-rmv-q30-l60-L60/  --popmap popmap-sub20-grp.txt -o ./$out -M $M -n $n -T 14 --min-samples-per-pop 0.8;
    done
done