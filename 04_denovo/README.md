# *de novo* approach
We run the *de novo* approach using STACKS. 
We used the denovo map.pl Stacks module to identify SNPs from reads. We performed the parameter optimization (Rivera-Colón and Catchen 2022) by running the de novo pipeline multiple times on a subset of 20 individuals, iterating over increasing M/n = 1–9 and per run. This method seeks the assembly parameters (M and n) that maximize the number of R80 loci in the dataset (the number of polymorphic loci present in at least 80% of samples). 

> [!NOTE]
>Data sets:
>
>**alt**: POP
>
>**grp**: Intra-P4
>
>**phylo** : Inter-C4

### The optimization:

For each group we run the shell scripts on ```opt-denvo-alt|grp|phylo```:
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
We run the de novo analysis with -M 3 -n 3 for all groups. 
<center>
	<figure>
   	 <img src="00.OPT-denovo/Result-graph_optmization_denovo_MN.png" width="550"
         alt="Output *de novo* optimization">
	</figure>
</center>

### Analysis
We ran PCA, fastSTRUCTURE, SPLISTREE and summaries statistics. The jupyter notebook and scripts are named conform its analysis.


### References

Rivera-Colón, A. G. & Catchen, J. Population genomics analysis with RAD, reprised: Stacks 2. Methods Mol. Biol. 2498, 99–149 (2022).