#!/usr/bin/env Rscript
# Carregar pacotes necessários
library(vcfR)
library(adegenet)
library(ggplot2)
library(dartR)

# Captura os argumentos de linha de comando
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Uso: Rscript script.R <arquivo_com_lista_de_prefixos>")
}

# O primeiro argumento é o arquivo com a lista de prefixos
prefix_list_file <- args[1]

# Ler os prefixos do arquivo (um por linha)
prefixos <- readLines(prefix_list_file)

# Loop para processar cada prefixo
for (prefix in prefixos) {
  
  # Definir os caminhos dos arquivos baseado no prefixo
  # Aqui, adicionamos "-maf5-th100.recode.vcf" ao nome do VCF
  vcf_file <- paste0("/data/users/sousal/03_compare_methods/07_filtering/",prefix, "-maf5-th100.recode.vcf")
  cat("Reading", prefix, "\n")
  
  # Para o popmap, usamos os 5 primeiros caracteres do prefixo (ajuste se necessário)
  popmap_file <- paste0("../popmap-", substr(prefix, 1, 11))
  
  # Define os nomes dos arquivos de saída
  output_svg <- paste0(prefix, ".svg")

  # Ler o VCF e convertê-lo para objeto genlight
  vcf <- read.vcfR(vcf_file)
  vcf_gl <- vcfR2genlight(vcf)
  
  # Ler o popmap e definir a população
  vcf_gl$other$loc.metrics <- read.table(popmap_file, header = FALSE, sep = "\t")
  pop(vcf_gl) <- vcf_gl$other$loc.metrics$V2
  
  # Realizar a PCA (ajuste o número de componentes, se necessário)
  pca1 <- glPca(vcf_gl, nf = 2)
  
  # Gerar o gráfico de PCA usando gl.pcoa.plot
  svg(output_svg, width = 8, height = 7)
  gl.pcoa.plot(pca1, vcf_gl, pop.labels = "pop", xaxis = 1, yaxis = 2, pt.size = 6, label.size = 2)
  dev.off()
  
  cat("Processado:", prefix, "\n")
}

cat("Processamento concluído!\n")

