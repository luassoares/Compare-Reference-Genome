#!/bin/bash
    for n in 9 10;
    do
        out=denovo-phylo.M${n}.n${n};
        echo $out;
        mkdir -p $out;
        denovo_map.pl --samples ../../02_filtered-adaptor-rmv-q30-l60-L60/  --popmap ../popmap-phylo29.txt -o ./$out -M $n -n $n -T 20 --min-samples-per-pop 0.8;
    done