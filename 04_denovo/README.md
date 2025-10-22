# *de novo* approach
We performed the de novo analysis using Stacks, following the pipeline described by Rivera-Colón and Catchen (2022). SNPs were identified using the denovo_map.pl module.

Parameter optimization was carried out on a subset of 20 individuals, running the de novo pipeline multiple times with increasing values of M and n (from 1 to 9). This optimization seeks the combination of parameters that maximizes the number of R80 loci—polymorphic loci present in at least 80% of the samples.

> [!NOTE]
>**Data sets**
>
>-**alt**: POP
>-**grp**: Intra-P4
>-**phylo** : Inter-C4

### Parameter optimization
For each dataset, we ran the following shell script ```opt-denvo-alt|grp|phylo```:
```shell
#!/bin/bash
    for n in 1 2 3 4 5 6 7 8 9 10;
    do
        out=denovo-ALT.M${n}.n${n};
        echo $out;
        mkdir -p $out;
        denovo_map.pl --samples ../../02_filtered-adaptor-rmv-q30-l60-L60/  --popmap ../popmap-sub20-alti.txt -o ./$out -M $n -n $n -T 14 --min-samples-per-pop 0.8;
    done
```	
#### Result
The optimal parameters identified were -M 3 -n 3, which were used for all groups. 
<center>
	<figure>
   	 <img src="00.OPT-denovo/Result-graph_optmization_denovo_MN.png" width="550"
         alt="Output *de novo* optimization">
	</figure>
</center>

### Analysis
After the optimized de novo assembly, we conducted:

>**PCA**
>**fastSTRUCTURE**
>**SPLITSTREE**
>**Summary statistics**

All notebooks and scripts are named according to their corresponding analyses.

### References

Rivera-Colón, A. G. & Catchen, J. Population genomics analysis with RAD, reprised: Stacks 2. Methods Mol. Biol. 2498, 99–149 (2022).