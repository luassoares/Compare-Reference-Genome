# *de novo* approach
We run the *de novo* approach using STACKS. 
We used the denovo map.pl Stacks module to identify SNPs from reads. We performed the parameter optimization (Rivera-Colón and Catchen 2022) by running the de novo pipeline multiple times on a subset of 20 individuals, iterating over increasing M/n = 1–9 and per run. This method seeks the assembly parameters (M and n) that maximize the number of R80 loci in the dataset (the number of polymorphic loci present in at least 80% of samples). 
## The optimization:

<img src="https://github.com/luassoares/Compare-Ref-Genome/blob/main/04_denovo/00.OPT-denovo/Result-graph_optmization_denovo_MN.png" width="150">

### References

Rivera-Colón, A. G. & Catchen, J. Population genomics analysis with RAD, reprised: Stacks 2. Methods Mol. Biol. 2498, 99–149 (2022).