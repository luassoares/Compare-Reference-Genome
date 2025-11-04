#!/bin/bash

for file in `cat ../../list-vcf-72-prefix2`;do
python ~/programs/vcf2phylip/vcf2phylip.py --input /data/users/sousal/03_compare_methods/07_filtering/${file}-maf5-th100.recode.vcf --nexus
done