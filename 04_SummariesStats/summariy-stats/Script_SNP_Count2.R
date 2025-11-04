setwd("/Users/luasoares/DOC/COMPARE/02_RefGeno_analysis/00_RESULTADOS")
library(tidyr)
library(scales)
library(ggtext)
library(patchwork)
library(ggplot2)
library(dplyr)
#Import the vcf count for all datasets
vcf_count<- read.csv("SNP-count.txt", sep = "\t") #ReferenceGenome table

#de novo table - organize to merge with the other
denovo <- read.csv("../../04_denovo/denovo_snp_count.csv")
denovo$Group<- gsub("alti", "alt80", denovo$Group)
denovo$Group<- gsub("grp", "grp41", denovo$Group)
denovo <- denovo %>%
  mutate(Missing = recode(Missing,
    "50" = "miss5",
    "80" = "miss8", 
    "90" = "miss9",
    "95" = "miss95"
  ))
## add column for method denovo
denovo$ReferenceGenome<- "denovo"

## adjust the table to merge with the other vcfs
colnames(denovo)<- c('VCF_File', 'Missing', 'SNP_Count','ReferenceGenome')
denovo<- denovo[,  c('VCF_File', 'ReferenceGenome', 'Missing', 'SNP_Count')]
vcf_count_complete <- vcf_count %>% 
  left_join(denovo, by = c("VCF_File" = "Group", 
                           "Missing" = "Missing",
													"ReferenceGenome"= "ReferenceGenome",
												  "SNP_Count"="Variant_Sites"))

## merge both tables
vcf_count_all <- rbind(vcf_count, denovo)

# Subsets per group
df_alt80 <- subset(vcf_count_all, VCF_File == "alt80")
df_grp41 <- subset(vcf_count_all, VCF_File == "grp41")
df_phylo <- subset(vcf_count_all, VCF_File == "phylo")

df_phylo$ReferenceGenome <- gsub("01_infll", "01_infl", df_phylo$ReferenceGenome)

## Define the colors and labels
colors = c("01_infl" = "#4792b0","02_axi" = "#dc5646","03_aaxi"= "#8a312b","04_secr"= "#fdc46d","05_nico"= "#A05C7B","06_habro"="#5E9D7E", "denovo"= "#b3b3b3")

label = c("01_infl" = expression(italic("P. inflata")),
           "02_axi" = expression(italic("P. axillaris I")),
           "03_aaxi"= expression(italic("P. axillaris II")),
           "04_secr"= expression(italic("P. secreta")),
           "05_nico"= expression(italic("N. sylvestris")),
           "06_habro" = expression(italic("S. habrochaites")),
					"denovo" = expression(italic("de novo")))

###### Graph for all the missing together #####

p1 <- ggplot(df_alt80, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = NA) +
  geom_text(aes(label = scales::label_number(scale = 1e-3, suffix = "K", accuracy = 0.1)(SNP_Count)),
            position = position_dodge(width = 0.9),
            vjust = -0.3,
            size = 2.5) +
  scale_fill_manual(values = colors, labels = label) +  # CORRIGIDO
  ggtitle("POP") +
  theme_bw() +
  theme(axis.text.x = element_blank()+
   strip.text = element_text(size = 12)) +
  facet_wrap(~Missing, ncol = 2, scales = "free_x", 
             labeller = labeller(
               Missing = c(
                 "miss5" = "50% missing",
                 "miss8" = "20% missing",
                 "miss9" = "10% missing",
                 "miss95" = "5% missing"
               ))) +
  scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +  # CORRIGIDO
  ylab("SNP count") + 
  xlab("VCF")

print(p1)

p2 <- ggplot(df_grp41, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = NA) +
  geom_text(aes(label = scales::label_number(scale = 1e-3, suffix = "K", accuracy = 0.1)(SNP_Count)),
            position = position_dodge(width = 0.9),
            vjust = -0.3,
            size = 2.5) +
  scale_fill_manual(values = colors, labels = label) +  # CORRIGIDO
  ggtitle("Intra-P4") +
  theme_bw() +
  theme(axis.text.x = element_blank()+
        strip.text = element_text(size = 12)) +
  facet_wrap(~Missing, ncol = 2, scales = "free_x", 
             labeller = labeller(
               Missing = c(
                 "miss5" = "50% missing",
                 "miss8" = "20% missing",
                 "miss9" = "10% missing",
                 "miss95" = "5% missing"
               ))) +
  scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +  # CORRIGIDO
  ylab("SNP count") + 
  xlab("VCF")

print(p2)

p3 <- ggplot(df_phylo, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = NA) +
  geom_text(aes(label = scales::label_number(scale = 1e-3, suffix = "K", accuracy = 0.1)(SNP_Count)),
            position = position_dodge(width = 0.9),
            vjust = -0.3,
            size = 2.5) +
  scale_fill_manual(values = colors, labels = label) +  # CORRIGIDO
  ggtitle("Intra-C5") +
  theme_bw() +
  theme(axis.text.x = element_blank() +
	strip.text = element_text(size = 12))+
  facet_wrap(~Missing, ncol = 2, scales = "free_x", 
             labeller = labeller(
               Missing = c(
                 "miss5" = "50% missing",
                 "miss8" = "20% missing",
                 "miss9" = "10% missing",
                 "miss95" = "5% missing"
               ))) +
  scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K")) +  # CORRIGIDO
  ylab("SNP count") + 
  xlab("VCF")

print(p3)

 ##Save graphs 
ggsave("SNPcount_ALT80.svg", plot=p1) 
ggsave("SNPcount_grp41.svg", plot=p2) 
ggsave("SNPcount_phylo.svg", plot=p3) 
final_plot <- p1 + p2 + p3 + plot_layout(guides = "collect") & theme(legend.position = "bottom")
print(final_plot)
ggsave("SNPcount_all2.svg", plot=final_plot, width = 520, height = 233, units = "mm")

final_plot+ theme(
  strip.text = element_text(size = 12)  # Apenas horizontal
)

#### only for miss9 ####

miss9 <- vcf_count_all %>% filter(Missing == "miss9")
write.csv(miss9, "vcf_count_miss9.txt")

p1 <- ggplot(miss9, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = NA) +
  geom_text(aes(label = scales::label_number(scale = 1e-3, suffix = "K", accuracy = 0.1)(SNP_Count)),
            position = position_dodge(width = 0.9),
            vjust = -0.3,
            size = 3) +
  scale_fill_manual(values = colors, labels = label,name = "Reference Genome") +
  theme_bw(base_size = 12) +
  theme(
    axis.text.x = element_blank(),
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.justification= "left",
    legend.title=(element_text(size = 12)),
    legend.title.position = "top",
    legend.text = element_text(size = 10)
  ) +
  facet_wrap(~VCF_File, ncol = 3, scales = "free_x",
   labeller = labeller(
               VCF_File = c(
                 "alt80" = "POP",
                 "grp41" = "Intra-P4",
                 "phylo" = "Inter-C5"
               ))) + 
	scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "K"))+
  ylab("SNP count") 

print(p1)
miss9_plot = p1
ggsave("SNPcount_miss9_2.svg",plot=miss9_plot, width = 320, height = 150, units = "mm")
