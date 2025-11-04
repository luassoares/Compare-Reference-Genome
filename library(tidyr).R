setwd("/Users/luasoares/DOC/COMPARE")
library(tidyr)
library(tidyverse)
library(scales)
library(ggtext)
library(patchwork)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

stats_miss9 = read.csv("11_ANALYSIS-NEW/Summaires_stats_miss9_VCF_STACKS.csv")
stats_miss9 = stats_miss9[,1:7]

pallets <- list(
  alt = "PuBu",
  grp = "Oranges",
  phylo = "Greens"
)
group_labels <- c(
  grp = "Intra-P4",
  phylo = "Inter-C5",
  alt = "POP"
)

genome_labels <- c(
  "sec" = "italic('P. secreta')",
  "aaxi" = "italic('P. axillaris II')",
  "axi" = "italic('P. axillaris I')",
  "hab" = "italic('P. habrochaites')",
  "inf" = "italic('P. inflata')",
  "nico" = "italic('N. sylvestris')",
  "zdenovo" = "italic('de novo')"
)

stats_long <- stats_miss9 %>%
  pivot_longer(
    cols = c(private,obs_het, fis, pi),  # columns to melt
    names_to = "stat",            # name of new column
    values_to = "value"           # values
  )
stats_long

ggplot(stats_long, aes(x = pop, y = value, fill = pop)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_grid(grp ~ genome + stat, scales = "free_y") +  # facets by group, genome, and stat
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  ) +
  labs(x = "", y = "Value", fill = "Population")

plots_boxplot <- stats_miss9%>%
  pivot_longer(cols = c(private, obs_het, fis, pi), 
               names_to = "metric", 
               values_to = "value") %>%
  group_split(grp, genome, metric) %>%
  map(~ {
    g <- unique(.x$grp)
    gen <- unique(.x$genome)
    met <- unique(.x$metric)
    
    # group_label <- if (!is.null(group_labels[[g]])) group_labels[[g]] else g
    # genome_label <- if (!is.null(genome_labels[[gen]])) genome_labels[[gen]] else gen
    
    pal <- brewer.pal(9, pallets[[g]])
    # title_text <- paste0(group_label, "~'-'~", genome_label, "~'-'~", met)
    
    ggplot(.x, aes(x = pop, y = value, fill = pop)) +
      geom_boxplot() +
      scale_fill_manual(values = pal) +
      theme_minimal(base_size = 14) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank(),
        legend.position = "none"
      ) 
      # labs(title = parse(text = title_text), x = "", y = met)
  })
