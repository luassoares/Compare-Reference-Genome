#!/bin/bash
#files

##VCFS ALT
for vcf in `cat ../../list-vcf-alt80`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-alt80 --fstats -t 18 
done

##VCFs GRP
for vcf in `cat ../../list-vcf-grp41`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-grp41 --fstats -t 18 
done

#VCFs phylo 

    #axiII
for vcf in `cat list-vcf-axiII`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-axiII --fstats -t 18 
done
    #axiI
for vcf in `cat list-vcf-axiI`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-axiI --fstats -t 18 
done
    #infl
for vcf in `cat list-vcf-infl`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-infl --fstats -t 18 
done
    #nico
for vcf in `cat list-vcf-nico`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-nico --fstats -t 18 
done
    #secr
for vcf in `cat list-vcf-secr`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-secr --fstats -t 18 
done
    #habro
for vcf in `cat list-vcf-habro`; do
    populations -V /data/users/sousal/03_compare_methods/07_filtering/${vcf}-maf5-th100.recode.vcf -O $vcf -M ../../popmap-phylo-habro --fstats -t 18 
done

