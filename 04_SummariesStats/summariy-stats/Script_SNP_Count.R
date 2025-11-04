setwd("/Users/luasoares/DOC/COMPARE/11_ANALYSIS-NEW/00_RESULTADOS")
library(tidyr)
library(scales)
library(ggtext)
library(patchwork)
library(ggplot2)

vcf_count<- read.csv("SNP-count.txt", sep = "\t")
# Subsets por grupo
df_alt80 <- subset(vcf_count, VCF_File == "alt80")
df_grp41 <- subset(vcf_count, VCF_File == "grp41")
df_phylo <- subset(vcf_count, VCF_File == "phylo")



ggplot(data=vcf_count, aes(x=VCF_File, y=SNP_Count)+
       geom_bar())

ggplot(vcf_count, aes(x=VCF_file, y=SNP_count))+
  geom_bar(fill="ReferenceGenome")+
  facet_wrap(~missing)

ggplot(vcf_count, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  facet_grid(VCF_File ~ ., scales = "free_x") +  # Subdivide em linhas por VCF_File
  theme_bw(base_size = 14) +
  labs(x = "Missing Data", y = "SNP Count", fill = "Reference Genome") +
  scale_fill_brewer(palette = "Set2") +
  theme(
    panel.grid = element_blank(),
    strip.text = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
colors = c("01_infl" = "#4792b0","02_axi" = "#dc5646","03_aaxi"= "#8a312b","04_secr"= "#fdc46d","05_nico"= "#A05C7B","06_habro"="#5E9D7E")

label = c("01_infl" = "P. inflata",
           "02_axi" = "P. axillaris I",
           "03_aaxi"= "P. axillaris II",
           "04_secr"= "P. secreta",
           "05_nico"= "N. sylvestris",
           "06_habro" = "S. habrochaites")

           # Gráfico 1
p1 <- ggplot(df_alt80, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
   geom_text(aes(label=scales::label_number(scale = 1e-3, suffix = "K",accuracy = 0.1)(SNP_Count)),
             position = position_dodge(width = 0.9),
             vjust= -0.3,
             size=2.5)+
  scale_color_manual(values = colors,
                       labels = label)+
  ggtitle("POP") +
  theme_bw() +
    theme(axis.text.x = element_blank())+
    facet_wrap(~Missing, ncol=2,  scales="free_x", 
               labeller = labeller(
                 Missing = c(
                   "miss5" = "50% missing",
                   "miss8" = "20% missing",
                   "miss9" = "10% missing",
                   "miss95"= "5% missing"
                 )))+
    scale_y_continuous(labels = label_number(scale = 1e-3, suffix = "K"))+
    ylab("SNP count")+xlab("VCF")
 # Gráfico 2
 p2 <- 
   ggplot(df_grp41, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
   geom_bar(stat = "identity", position = "dodge", color = "black") +
   geom_text(aes(label=scales::label_number(scale = 1e-3, suffix = "K",accuracy = 0.1)(SNP_Count)),
             position = position_dodge(width = 0.9),
             vjust= -0.3,
             size=2.5)+
   ggtitle("**Intra-P4**") +
   theme_bw() +
   theme(axis.text.x = element_blank())+
   facet_wrap(~Missing, ncol=2,  scales="free_x", 
              labeller = labeller(
                Missing = c(
                  "miss5" = "50% missing",
                  "miss8" = "20% missing",
                  "miss9" = "10% missing",
                  "miss95"= "5% missing"
                )))+
   scale_y_continuous(labels = label_number(scale = 1e-3, suffix = "K"))+
   ylab("SNP count")+xlab("VCF")
 # Gráfico 2
 p3 <- 
   ggplot(df_phylo, aes(x = Missing, y = SNP_Count, fill = ReferenceGenome)) +
   geom_bar(stat = "identity", position = "dodge", color = "black") +
     geom_text(aes(label=scales::label_number(scale = 1e-3, suffix = "K",accuracy = 0.1)(SNP_Count)),
               position = position_dodge(width = 0.9),
               vjust= -0.3,
               size=2.5)+
   ggtitle("**Intra-C4**") +
   theme_bw() +
   theme(axis.text.x = element_blank(),strip.text = element_markdown(size = 12))+
   facet_wrap(~Missing, ncol=2,  scales="free_x", 
              labeller = labeller(
                Missing = c(
                  "miss5" = "50% missing",
                  "miss8" = "20% missing",
                  "miss9" = "10% missing",
                  "miss95"= "5% missing"
                )))+
   scale_y_continuous(labels = label_number(scale = 1e-3, suffix = "K"))+
   ylab("SNP count")+xlab("VCF")
ggsave("SNPcount_ALT80.svg", plot=p1) 
ggsave("SNPcount_grp41.svg", plot=p2) 
ggsave("SNPcount_phylo.svg", plot=p3) 
final_plot <- p1 + p2 + p3 + plot_layout(guides = "collect") & theme(legend.position = "bottom")
ggsave("SNPcount_all.svg", plot=final_plot)
