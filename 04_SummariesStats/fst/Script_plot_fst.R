setwd("/Users/luasoares/DOC/COMPARE/04_denovo/00_denovo_populations")
library(tidyr)
library(tidyverse)
library(scales)
library(ggtext)
library(patchwork)
library(ggplot2)
library(dplyr)
library(RColorBrewer)

files <- list.files(pattern = "*populations*\\.fst_summary\\.tsv$", 
                   recursive = TRUE, 
                   full.names = TRUE)
# Create the list of files
fst_denovo <- lapply(files, FUN = function(x) read.csv(x, sep = '\t', row.names=1))

#Use the basename as name for the list
names <- basename(dirname(files)) %>% gsub("*_populations_(\\d+).*", "\\1", .)  %>% 
                                      gsub("alti", "alt", .) %>%
                                      gsub("([a-z]+)(\\d)(0)", "\\1-zdenovo-\\2", .)
names <- gsub("95","-zdenovo-95", names)
names(fst_denovo) <- names

fst_denovo <- lapply(fst_denovo, function(x) round(x, 2))

#Color pallets

pallets <- list(
  alt = "PuBu",
  grp = "Oranges",
  phylo = "Greens"
)


#Transform to long the matrix for the heatmap plots
ref_long <- imap_dfr(fst_denovo, ~ {
  parts <- str_split(.y, "-")[[1]]

  group   <- parts[1]
  method  <- parts[2]
  dataset <- parts[3]

  .x %>%
    as.data.frame() %>%
    rownames_to_column("Pop1") %>%
    pivot_longer(-Pop1, names_to = "Pop2", values_to = "Fst") %>%
    mutate(
      dataset = dataset, 
      group = group,
      method = method
    )
})

#Remove NA lines
ref_long <- ref_long %>% 
  filter(!is.na(Fst))

# Custom labels for datasets
dataset_labels <- c(
  "5" = "5% missing",
  "8" = "20% missing",
  "9" = "10% missing",
  "95" = "5% missing"
)
group_labels <-c(
  "alt" = "POP",
  "grp" = "Intra-P4",
  "phylo" = "Inter-C5"
)

# Make a plot per group
plots <- ref_long %>%
  group_split(group) %>%
  set_names(unique(ref_long$group)) %>%
  map(~ {
    g <- unique(.x$group)
    pal <- brewer.pal(9, pallets[[g]])

    title_text <- group_labels[[g]]

    ggplot(.x, aes(Pop1, Pop2, fill = Fst)) +
      geom_tile(color = "white") +
      geom_text(aes(label = Fst), color = "black") +
      scale_fill_gradientn(colors = pal, na.value = "grey90", guide="none") +
      facet_wrap(~ dataset, labeller = labeller(dataset = dataset_labels)) +
      theme_minimal(base_size = 14) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      ) +
      labs(title = title_text, fill = "Fst", x = "", y = "")
  })

# Combinar todos os plots
plots[1]
all <-wrap_plots(plots)
all

#Save plot in png and svg - just change the extension
ggsave("heatmaps_fst_denovo.svg",
       plot = all,           # o objeto ggplot
       width = 16,          # largura em polegadas
       height = 6,         # altura em polegadas
       dpi = 300)          # resolução (opcional)

######### genome reference fsts ######

names_ref <- list.files(
  path = "/Users/luasoares/DOC/COMPARE/11_ANALYSIS-NEW/01_POPULATIONS/01_RESULTS",
  pattern = "p\\.fst_summary\\.tsv$",
  recursive = TRUE,
  full.names = FALSE
)
files_ref <- list.files(
  path = "/Users/luasoares/DOC/COMPARE/11_ANALYSIS-NEW/01_POPULATIONS/01_RESULTS",
  pattern = "p\\.fst_summary\\.tsv$",
  recursive = TRUE,
  full.names = TRUE
)
fst_ref <- lapply(files_ref, FUN = function(x) read.csv(x, sep = '\t',row.names=1))

#Use the basename as name for the list
names <- basename(names_ref) %>% 
        gsub("-maf5.*|miss*|(41|80)-", "", .) %>%  # Combine removals with |
        gsub("axiII", "aaxi", .) %>%   # Do axiII first
        gsub("axiI", "axi", .) %>%
        gsub("infl", "inf",.) %>%
        gsub("habro","hab",.) %>%
        gsub("secr", "sec",.)
names

names(fst_ref)<- names

# Round all numeric values to 2 decimal places
fst_ref <- lapply(fst_ref, function(x) round(x, 2))

# Transform to long format for heatmap
ref_long <- imap_dfr(fst_ref, ~ {
  # Split name by dash
  parts <- str_split(.y, "-")[[1]]
  
  group <- parts[1]    # first part: alt, grp, phylo
  genome <- parts[2]   # second part: aaxi, axi, hab, etc.
  dataset <- parts[3]  # third part: 5, 8, 9, 95
  
  .x %>%
    as.data.frame() %>%
    rownames_to_column("Pop1") %>%
    pivot_longer(-Pop1, names_to = "Pop2", values_to = "Fst") %>%
    mutate(
      group = group,
      genome = genome,
      dataset = dataset
    )
})

#Remove NA lines
ref_long <- ref_long %>% 
  filter(!is.na(Fst))

#Palletes
pallets <- list(
  alt = "PuBu",
  grp = "Oranges",
  phylo = "Greens"
)
genome_labels <- c(
  "sec" = "italic('P. secreta')",
  "aaxi" = "italic('P. axillaris II')",
  "axi" = "italic('P. axillaris I')",
  "hab" = "italic('P. habrochaites')",
  "inf" = "italic('P. inflata')",
  "nico" = "italic('N. sylvestris')"
)

# Make a plot per group
plots <- ref_long %>%
  group_split(group,genome) %>%
  set_names(unique(paste(ref_long$group, ref_long$genome, sep = "-"))) %>%
  map(~ {
    g <- unique(.x$group)
    gen <- unique(.x$genome)
    pal <- brewer.pal(9, pallets[[g]])

    ggplot(.x, aes(Pop1, Pop2, fill = Fst)) +
      geom_tile(color = "white") +
      geom_text(aes(label = Fst), color = "black") +
      scale_fill_gradientn(colors = pal, na.value = "grey90", guide="none") +
      facet_wrap(~ dataset, labeller = as_labeller(dataset_labels))+
      theme_minimal(base_size = 14) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      ) +
	    labs(
      title = parse(text = paste0(group_labels[[g]], "- ", genome_labels[[gen]])),
      fill = "Fst", x = "", y = ""
)
  })
plots[1]
# Combinar todos os plots
all   <- wrap_plots(plots, ncol = 3)
all
alti  <- wrap_plots(plots[1:6],ncol = 2)
grp   <- wrap_plots(plots[7:12],ncol = 2)
phylo <- wrap_plots(plots[13:18],ncol = 2)


ggsave("heatmaps_fst_ref_genomes.svg",
       plot = all,           # o objeto ggplot
       width = 15,          # largura em polegadas
       height = 25,         # altura em polegadas
       dpi = 300,
      limitsize = FALSE)          # resolução (opcional)

ggsave("heatmaps_fst_alti_genomes.svg",
       plot = alti,           # o objeto ggplot
       width = 8,          # largura em polegadas
       height = 12,         # altura em polegadas
       dpi = 300,
      limitsize = FALSE)          # resolução (opcional)

ggsave("heatmaps_fst_grp_genomes.svg",
       plot = grp,           # o objeto ggplot
       width = 10,          # largura em polegadas
       height = 15,         # altura em polegadas
       dpi = 300,
      limitsize = FALSE)          # resolução (opcional)

ggsave("heatmaps_fst_phylo_genomes.svg",
       plot = phylo,           # o objeto ggplot
       width = 10,          # largura em polegadas
       height = 15,         # altura em polegadas
       dpi = 300,
      limitsize = FALSE)          # resolução (opcional)

########## de novo + genome - 10% missing data ############

all <- c(fst_ref, fst_denovo)
# Regenerate the long format with the combined data and filter for dataset 9
miss9_long <- imap_dfr(all, ~ {
  parts <- str_split(.y, "-")[[1]]
  
  group <- parts[1]
  genome <- parts[2]
  dataset <- parts[3]
  
  .x %>%
    as.data.frame() %>%
    rownames_to_column("Pop1") %>%
    pivot_longer(-Pop1, names_to = "Pop2", values_to = "Fst") %>%
    mutate(
      group = group,
      genome = genome,
      dataset = dataset
    )
}) %>%
  filter(dataset == "9") %>% 
  filter(!is.na(Fst))
genome_labels <- c(
  "sec" = "italic('P. secreta')",
  "aaxi" = "italic('P. axillaris II')",
  "axi" = "italic('P. axillaris I')",
  "hab" = "italic('P. habrochaites')",
  "inf" = "italic('P. inflata')",
  "nico" = "italic('N. sylvestris')",
  "zdenovo" = "italic('de novo')"
)

# Make a plot per group
plots_miss9 <- miss9_long %>%
  group_split(group,genome) %>%
  set_names(unique(paste(miss9_long$group, miss9_long$genome, sep = "-"))) %>%
  map(~ {
    g <- unique(.x$group)
    gen <- unique(.x$genome)
    pal <- brewer.pal(9, pallets[[g]])

    ggplot(.x, aes(Pop1, Pop2, fill = Fst)) +
      geom_tile(color = "white") +
      geom_text(aes(label = Fst), color = "black") +
      scale_fill_gradientn(colors = pal, na.value = "grey90", guide="none") +
      facet_wrap(~ dataset)+
      theme_minimal(base_size = 14) +
      theme(
        # axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank(),
        strip.text = element_blank()
      ) +
	    labs(
      title = parse(text=(genome_labels[gen])),
      fill = "Fst", x = "", y = ""
)
  })

miss9 <- wrap_plots(plots_miss9, nrow = 3) +
  plot_annotation(
    title = expression(F[ST]~" - 10% missing data"),
      theme = theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5)
    )
  )
miss9

ggsave("heatmaps_fst_miss9_all.svg",
       plot = miss9,           # o objeto ggplot
       width = 25,          # largura em polegadas
       height = 10,         # altura em polegadas
       dpi = 300,
      limitsize = FALSE)          # resolução (opcional)

