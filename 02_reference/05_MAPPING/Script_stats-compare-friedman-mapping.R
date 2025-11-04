library(tidyverse)
library(ggpubr)
library(rstatix)
mapping <- read.csv("/Users/luasoares/DOC/COMPARE/02_RefGeno_analysis/05_MAPPING/porcent_mapping_genomes.txt", sep = "\t")
snp <- read.csv("../../02_RefGeno_analysis/00_RESULTADOS/vcf_count_miss9.txt")
#Get genomes names
genomes <- colnames(mapping[,3:8])


#Long form of the table
mapping_lg <- mapping %>%
  gather(key = "genome", value = "mapping", all_of(genomes)) %>%
  convert_as_factor(Samples, Grupo, genome)
head(mapping_lg, 3)

# Summary statistics
summaries_stats <- mapping_lg %>%
  group_by(Grupo, genome) %>%
  get_summary_stats(mapping, type = "common")

write.csv(file = "summaries_stats_mapping.csv", summaries_stats)
ggboxplot(mapping_lg, x = "genome", y = "mapping", add = "jitter", facet.by = "Grupo")

res.fried <- mapping_lg %>% 
  group_by(Grupo) %>%  # Test separately for each group
  friedman_test(mapping ~ genome | Samples)

res.fried
write.csv(res.fried, file="output-friedman-test-mapping.csv")
# POST-HOC WILCOXON PAIRWISE COMPARISONS
pwc <- mapping_lg %>%
  group_by(Grupo) %>%  # Separate tests for each group
  wilcox_test(mapping ~ genome, paired = TRUE, p.adjust.method = "bonferroni")

pwc
write.csv(pwc, "outpout-wilcox-test-mapping.csv")
# View only significant comparisons
pwc %>% filter(p.adj < 0.05)


# VISUALIZATION
# For each group separately
for(grupo in unique(mapping_lg$Grupo)) {
  # Filter data for this group
  data_subset <- mapping_lg %>% filter(Grupo == grupo)
  pwc_subset <- pwc %>% filter(Grupo == grupo)
  
  # Get Friedman test result for this group
  fried_subset <- res.fried %>% filter(Grupo == grupo)
  
  # Add positions for p-values
  pwc_subset <- pwc_subset %>% add_xy_position(x = "genome")
  
  # Create plot
  p <- ggboxplot(data_subset, x = "genome", y = "mapping", add = "point") +
    stat_pvalue_manual(pwc_subset, hide.ns = TRUE) +
    labs(
      title = paste("Mapping percentages -", grupo),
      subtitle = get_test_label(fried_subset, detailed = TRUE),
      caption = get_pwc_label(pwc_subset)
    ) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  print(p)
}
# ALTERNATIVE: All groups in one plot with facets
pwc_all <- pwc %>% add_xy_position(x = "genome", group = "Grupo")

ggboxplot(mapping_lg, x = "genome", y = "mapping", 
          add = "point", facet.by = "Grupo") +
  stat_pvalue_manual(pwc_all, hide.ns = TRUE) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    title = "Mapping percentages across genomes",
    subtitle = "Friedman test with pairwise Wilcoxon comparisons"
  )
library(rcompanion)
library(rstatix)

# Get compact letter display for each group
cld_results <- pwc %>%
  group_by(Grupo) %>%
  group_modify(~ {
    pwc_subset <- as.data.frame(.x)
    pwc_subset$Comparison <- paste(pwc_subset$group1, "-", pwc_subset$group2)
    
    cld <- cldList(p.adj ~ Comparison, data = pwc_subset)
    cld
  })

cld_results

write.csv(cld_results, "cld-posthoc-mapping.csv")


library(lme4)
library(lmerTest)


for (grp in unique(mapping_lg$Grupo)){
  tbl_flt <- mapping_lg %>% filter(Grupo == grp)
  model <- lmer(mapping ~genome + (1 | Samples), data = tbl_flt)
  pairwise_results <- contrast(emmeans(model, ~genome), method="pairwise", adjust="tukey")
  print(grp)
  print(model)
  print(pairwise_results)
  print(cld(emmeans(model, ~genome), Letters = letters))
}
model <- lmer(mapping ~ genome + (1 | Grupo), data = mapping_lg)
summary(model)
anova(model)

library(lmerTest)
library(emmeans)
library(multcomp)

model <- lmer(pi ~ ReferenceGenome + (1|Population), data = df)

# Significant effect of reference genome?
anova(model)

# Pairwise comparisons (Tukey-adjusted)
pairwise_results <- contrast(emmeans(model, ~genome), method="pairwise", adjust="tukey")
pairwise_results

# Compact letter display for easy interpretation
cld(emmeans(model, ~genome), Letters = letters)
