# ============================================================
# Statistical comparison of mapping percentages among genomes
# ============================================================

# Load required packages
library(tidyverse)    # For data wrangling and reshaping
library(lme4)         # For fitting linear mixed-effects models
library(lmerTest)     # For obtaining p-values in LMMs
library(emmeans)      # For estimated marginal means and pairwise comparisons

# ------------------------------------------------------------
# 1. Import mapping data
# ------------------------------------------------------------
# The table contains mapping percentages for each sample
# across six different reference genomes. Columns represent
# the genomes, and rows correspond to individual samples.
# Additional columns include sample ID ("Samples") and group ("Grupo").

mapping <- read.csv(
  "/Users/luasoares/DOC/COMPARE/02_RefGeno_analysis/05_MAPPING/porcent_mapping_genomes.txt",
  sep = "\t"
)

# ------------------------------------------------------------
# 2. Reshape data to long format
# ------------------------------------------------------------
# The 'gather()' function transforms the wide table (genomes as columns)
# into a long format with one observation per sample-genome combination.
# This structure is required for mixed-effects modeling.

genomes <- colnames(mapping)[!(colnames(mapping) %in% c("Samples", "Grupo"))]

mapping_lg <- mapping %>%
  gather(key = "genome", value = "mapping", all_of(genomes)) %>%
  convert_as_factor(Samples, Grupo, genome)

# ------------------------------------------------------------
# 3. Fit mixed-effects models by group
# ------------------------------------------------------------
# For each dataset group (variable "Grupo"), we fit a linear mixed model
# testing for differences in mapping percentage among genomes, while
# including sample identity as a random effect to account for repeated measures.

for (grp in unique(mapping_lg$Grupo)) {

  # Filter data for the current group
  tbl_flt <- mapping_lg %>% filter(Grupo == grp)

  # Fit linear mixed model
  model <- lmer(mapping ~ genome + (1 | Samples), data = tbl_flt)

  # Obtain estimated marginal means and perform Tukey-corrected pairwise comparisons
  pairwise_results <- contrast(emmeans(model, ~ genome), method = "pairwise", adjust = "tukey")

  # Display results
  print(grp)
  print(summary(model))
  print(pairwise_results)
  print(cld(emmeans(model, ~ genome), Letters = letters))
}

# ------------------------------------------------------------
# 4. Interpretation
# ------------------------------------------------------------
# The model tests whether mapping percentages significantly differ
# among reference genomes within each group. The 'cld()' function
# summarizes pairwise results with letters indicating statistically
# distinct groups (genomes that share a letter are not significantly different).

# End of script
