#!/bin/bash
for file in `cat list-str-phylo`; do
structure_threader run -K 10 -R 10 -i $file -o RESULT_${file} -t 16 -fs ~/.local/bin/fastStructure --pop popmap-phylo
done

for file in `cat list-str-alt80`; do
structure_threader run -K 10 -R 10 -i $file -o RESULT_${file} -t 16 -fs ~/.local/bin/fastStructure --pop popmap-alt80
done

for file in `cat list-str-grp41`; do
structure_threader run -K 10 -R 10 -i $file -o RESULT_${file} -t 16 -fs ~/.local/bin/fastStructure --pop popmap-grp41
done