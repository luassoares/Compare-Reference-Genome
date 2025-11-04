# Evaluating the Impact of Reference Genome Choice on SNP Calling and Population Genomics in Recently Diverged Species

### Abstract
The use of RAD-seq data in population genomics is strongly influenced by bioinformatic processing choices, particularly in SNP discovery and demographic inference. A key decision involves whether to adopt a *de novo* or reference-based approach, with the latter introducing potential biases depending on the genetic proximity between the reference genome and the focal species. While it is generally recommended to use high-quality genomes from closely related taxa, little is known about how relatedness affects evolutionary inferences, especially in systems of recent and rapid divergence.

Here, we evaluate how the choice of reference genome influences SNP calling and downstream genetic analyses in recently diverged lineages of *Petunia* and *Calibrachoa*. We compare multiple reference genomes that vary in genetic distance from the target species, assessing their impact on population genetic parameters and phylogenetic relationships. Despite differences in SNP counts and dataset composition, overall patterns of genetic diversity, population structure, and evolutionary relationships remained consistent across references. These results suggest that for recently diverged taxa, reference genome choice may be less critical than previously assumed, as genetic similarity within this evolutionary timescale appears sufficient to recover key evolutionary patterns.

---

## Repository Overview

This repository contains the scripts and workflows used to:
1. Preprocess RAD-seq reads  
2. Perform both reference-based and *de novo* SNP calling  
3. Filter and analyze resulting VCF files  
4. Run population-level analyses (e.g., F-statistics, PCA, Structure and FastStructure)  


---
During the analysis the dataset was called differently. For clarity of the paper we changed to:

> [!NOTE]
>**Data sets**
>
>-**alt**: POP
>
>-**grp**: Intra-P4
>
>-**phylo** : Inter-C4



## Filter Raw Reads
#### Reference Genome
Reads were quality-filtered with a minimum read length of **50 bp**.

```bash
for sample in $(cat list_all_samples); do
  fastq-mcf -q 30 -l 50 \
  -o ./02_filtered/${sample}.FASTQ.gz ./01_raw/${sample}.FASTQ.gz
done
```

#### *de novo*
For *de novo* assemblies (STACKS requirement), reads were trimmed to a uniform length. For pop we trimmed to 100pb and for Intra-P4 and Inter-C5 for 60 pb.

```bash
# Example for POP
for sample in $(cat list_POP); do
  fastq-mcf -q 30 -l 100 -L 100 \
  -o ./02_filtered/${sample}.FASTQ.gz ./01_raw/${sample}.FASTQ.gz
done

# Example for Intra-P4 and Inter-C5
for sample in $(cat list_Intra-P4_3); do
  fastq-mcf -q 30 -l 60 -L 60 \
  -o ./02_filtered/${sample}.FASTQ.gz ./01_raw/${sample}.FASTQ.gz
done
```
## Reference-based Workflow
### 1. Read Mapping to Reference Genome

```bash
for sample in $(cat list_samples); do
  bwa mem -t 16 reference_genomes/genome1.fasta 02_filtered/${sample}.FASTQ.gz | \
  samtools view -F 4 -Sb | \
  samtools sort -@16 -o 03_mapping/${sample}.genome1.bam
done
```
---
### 2. Merge all files in one bam 

``` bash
bamaddrg -b sample1.genome1.bam -s sample1 -b sample2.genome1.bam -s sample2 ... -b samplex.genome1.bam -s samplex > all_samples.genome1.bam
```

---

### 3. SNP Calling with FreeBayes

```bash
freebayes -b all_samples.genome1.bam \
-f reference_genomes/genome1.fasta \
-v results/dataset.genome1.vcf \
-m 30 -q 30 --min-coverage 10 --limit-coverage 10000
```

---

### 4. Split VCFs per Dataset

```bash
bcftools view -S list-POP -o POP.vcf all_samples.genome1.vcf
bcftools view -S list-Intra-P4 -o Intra-P4.vcf all_samples.genome1.vcf
bcftools view -S list-Inter-C5 -o Inter-C5.vcf all_samples.genome1.vcf
```

---

### 5. Filter VCF Files

```bash
# Filtering example for POP
for vcf in $(cat list_vcf_POP); do
  vcftools --vcf ${vcf}.vcf \
  --out ${vcf}-filtered \
  --max-missing 0.9 --max-alleles 2 --min-alleles 2 \
  --remove-indels --maf 0.03 --thin 100 \ #maf of 0.05 to Intra-P4 and Inter-C5
  --recode --recode-INFO-all
done
```

---

### 6. Count SNPs in Each VCF

```bash
#!/bin/bash
input_file=$1
output_file="snp_counts.txt"

echo -e "VCF_File\tSNP_Count" > $output_file
while read -r vcf; do
  count=$(grep -v "#" ${vcf}.recode.vcf | wc -l)
  echo -e "${vcf}\t${count}" >> $output_file
done < "$input_file"
```

---

### 7. Population Genetic Analyses (STACKS)

```bash
for vcf in $(cat list_vcf_POP); do
  populations -V 07_filtering/${vcf}-filtered.recode.vcf \
  -O $vcf -M popmap_POP --fstats -t 18
done
```

---

### 8. Extract Summary Statistics

```bash
for prefix in $(cat list_vcf_prefixes); do
  cd $prefix
  cp ${prefix}-filtered.recode.p.sumstats_summary.tsv ../RESULTS/
  cp ${prefix}-filtered.recode.p.fst_summary.tsv ../RESULTS/
  cd ../
done
```
---

## *De Novo* Approach

*De novo* analyses were performed using **Stacks v2** (Rivera-Colón & Catchen, 2022). SNPs were identified with `denovo_map.pl`, and parameter optimization was based on maximizing the number of R80 loci (loci present in ≥80% of samples).

### Parameter Optimization

Example optimization script (`opt-denovo.sh`):

```bash
#!/bin/bash
for n in {1..9}; do
  out=denovo_dataset.M${n}.n${n}
  mkdir -p $out
  denovo_map.pl --samples ../02_filtered/ \
  --popmap ../popmap-subset.txt \
  -o ./$out -M $n -n $n -T 14 --min-samples-per-pop 0.8
done
```

**Optimal parameters:** `-M 3 -n 3`

<p align="center">
  <img src="03_denovo/00.OPT-denovo/Result-graph_optmization_denovo_MN.png" width="500" alt="Optimization results">
</p>

## Downstream Analyses for both

* **Summary Statistics**
* **PCA**
* **fastSTRUCTURE**
* **SPLITSTREE**


All corresponding scripts are available in the dedicated directory.

---

## Software Requirements

| Software       | Version                                           | Reference                                            |
| -------------- | ------------------------------------------------- | ---------------------------------------------------- |
| **Stacks**     | v2.64                                             | Catchen et al. (2013); Rivera-Colón & Catchen (2022) |
| **BWA**        | v0.7.17                                           | Li & Durbin (2009)                                   |
| **SAMtools**   | v1.19                                             | Li et al. (2009)                                     |
| **FreeBayes**  | v1.3.7                                            | Garrison & Marth (2012)                              |
| **VCFtools**   | v0.1.17                                           | Danecek et al. (2011)                                |
| **bcftools**   | v1.19                                             | Li (2011)                                            |
| **R**          | v4.3.3                                            | R Core Team (2023)                                   |
| **R packages** | tidyverse, dartR, vcfR, adegenet, ggpubr, rstatix |                                                      |

---

### References

* Catchen, J. M., Amores, A., Hohenlohe, P., Cresko, W., & Postlethwait, J. (2011). *Stacks: Building and genotyping loci de novo from short-read sequences.* G3: Genes, Genomes, Genetics, 1(3), 171–182.
* Rivera-Colón, A. G., & Catchen, J. (2022). *Population genomics analysis with RAD, reprised: Stacks 2.* Methods in Molecular Biology, 2498, 99–149.
* Li, H., & Durbin, R. (2009). *Fast and accurate short read alignment with Burrows–Wheeler transform.* Bioinformatics, 25(14), 1754–1760.
* Garrison, E., & Marth, G. (2012). *Haplotype-based variant detection from short-read sequencing.* arXiv preprint arXiv:1207.3907.
* Danecek, P. et al. (2011). *The variant call format and VCFtools.* Bioinformatics, 27(15), 2156–2158.


**Contact:**
[Luana Sousa]
Postdoctoral Researcher – Comparative Genomics


---