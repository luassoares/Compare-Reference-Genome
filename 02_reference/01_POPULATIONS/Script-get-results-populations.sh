#!/bin/bash

for prefix in `cat ../../list-vcf-72-prefix2`; do
cd $prefix
cp ${prefix}-maf5-th100.recode.p.sumstats_summary.tsv ${prefix}-maf5-th100.recode.p.fst_summary.tsv ../RESULTS/
cd ../
done