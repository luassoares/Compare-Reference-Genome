# Reference Genome

## Overview
This folder contains genomic analyses based on reference genome data, focusing on population structure, genetic diversity, and phylogenetic relationships. It includes results from tools such as Stacks, PCA, fastSTRUCTURE, and SPLISTREE, applied to various datasets (e.g., alt80, grp41, phylo).

## Contents
| Folder | Description |
|--------|--------------|
| **00_RESULTADOS/**| Final results including figures (e.g., PCA plots, fastSTRUCTURE visualizations, phylogenetic trees) and summary files from analyses with missing data threshold of 9%.
| **01_POPULATIONS/**| Lists of VCF files for different populations and a bash script |(`Script-run-populations-all-vcfs.sh`) to run Stacks populations analysis.
| **02_PCA/**| Principal component analysis plots and R scripts (`Script-run-PCA-pet.R`, |`Script-run-PCA-phylo.R`) for generating PCA visualizations.
|-**03_fastSTRUCTURE/**| Input files (.str), results (meanQ files, chooseK.txt), and scripts for |fastSTRUCTURE analysis, including R scripts for input preparation and bash scripts for execution.
| **04_SPLISTREE/**| Nexus files for phylogenetic analysis using SPLISTREE, filtered by MAF and missing |data thresholds.
| **05_MAPPING/**| Mapping statistics (e.g., counts, percentages) and R scripts for statistical |comparisons (Friedman tests, post-hoc analysis).
| **Root files**| Population maps (popmap-*.txt), VCF lists (list-vcf-*), and tree files (TREE-compare.|tree, Stacks-Result-*.svg) for various datasets.

## Softwares
- R (for statistical analysis and plotting)
- fastSTRUCTURE (for population structure inference)
- SPLISTREE (for phylogenetic network analysis)
- Stacks (for population genomics)
