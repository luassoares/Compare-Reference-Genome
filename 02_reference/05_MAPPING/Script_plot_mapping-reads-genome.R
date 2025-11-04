setwd("/Users/luasoares/DOC/COMPARE/02_RefGeno_analysis/05_MAPPING")
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)

mapping_all<- read.csv("porcent_mapping_genomes.txt", sep = "\t")

mapping_gt <- gather(mapping_all, key = "ReferenceGenome", value = "PorcMapping", -Samples,-Grupo)
colors = c("#A05C7B","#dc5646","#8a312b","#4792b0","#fdc46d","#5E9D7E")
group_lines <- c(80,121) 


mapping_plot_facet<- 
  ggplot(data = mapping_gt, aes(x = Samples, y = PorcMapping, group = ReferenceGenome)) +
  geom_line(aes(color = ReferenceGenome), size = 1.5, alpha = 0.8) +
  scale_color_manual(values = colors, name = "Reference Genome",
                       labels = c("N. sylvestris", "P. axillaris I", "P. axillaris II ", "P. inflata","P. secreta","P. habrochaites")) +
  ylab("Mapping Percentage") +
  xlab("Samples") +
  theme_minimal() +
  # theme_few()+
  theme_bw(base_size = 14)+
  theme(
           panel.grid = element_blank(),
           panel.grid.major.y = element_line(colour = "#e3e1e1", linetype = 2),
           axis.text.x = element_blank(),  
           axis.text.y = element_text(size = 12),
           axis.ticks.x = element_blank(),
           legend.position = "bottom",
           legend.box = "horizontal",
           legend.justification= "left",
           legend.title=(element_text(size = 12)),
           legend.title.position = "left",
           legend.text = element_text(size = 10)
           ) +
  theme(axis.text.x = element_text()) +
  facet_grid(. ~ Grupo, scales = "free_x", space = "free_x",margins = "am", labeller = 
  labeller(Grupo = c(
                 "alt80" = "POP",
                 "grp41" = "Intra-P4",
                 "phylo" = "Inter-C5"# Divide em 3 gráficos com base na coluna Group
               )))
mapping_plot_facet
ggsave("mapping-percentagem2.svg", plot = mapping_plot_facet, width = 19.3, height = 6.42)

                     