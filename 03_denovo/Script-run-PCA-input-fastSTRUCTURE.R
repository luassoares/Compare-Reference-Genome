#!/usr/bin/env Rscript 
# Load required packages
library(vcfR)
library(adegenet)
library(ggplot2)
library(dartR)

# Capture command line arguments
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript script.R <file_with_prefix_list>")
}

# The first argument is the file with the list of prefixes
prefix_list_file <- args[1]

# Read prefixes from file
prefixes <- readLines(prefix_list_file)

# Loop to process each prefix
for (prefix in prefixes) {
  
  tryCatch({
    # Define file paths
    vcf_file <- paste0("01_vcfs/", prefix, ".vcf")
    
    # Check if VCF file exists
    if (!file.exists(vcf_file)) {
      cat("❌ VCF file not found:", vcf_file, "\n")
      next
    }
    
    cat("📊 Processing:", prefix, "\n")
    
    # Extract group name from prefix
    group_name <- sub("_.*", "", prefix)
    
    # Define popmap file
    popmap_file <- paste0("popmap_", group_name)
    
    # Check if popmap file exists
    if (!file.exists(popmap_file)) {
      cat("❌ Popmap file not found:", popmap_file, "\n")
      next
    }
    
    # Define output file
    output_svg <- paste0("02_PCA/",prefix, "_pca.svg")
    output_data <- paste0("02_PCA/",prefix, "_pca_data.txt")

    # Read VCF file
    vcf <- read.vcfR(vcf_file)
    vcf_gl <- vcfR2genlight(vcf)
    
    # Read popmap
    popmap_data <- read.table(popmap_file, header = FALSE, sep = "\t", 
                             stringsAsFactors = FALSE)
    colnames(popmap_data) <- c("sample", "population")
    
    # Match samples with popmap
    sample_names <- indNames(vcf_gl)
    pop_vector <- character(length(sample_names))
    
    for (i in 1:length(sample_names)) {
      sample_match <- which(popmap_data$sample == sample_names[i])
      if (length(sample_match) > 0) {
        pop_vector[i] <- popmap_data$population[sample_match[1]]
      } else {
        pop_vector[i] <- "Unknown"
        cat("⚠️  Sample not found in popmap:", sample_names[i], "\n")
      }
    }
    
    # Set populations
    pop(vcf_gl) <- pop_vector
    
    ## Perform PCA
    # nf = an integer indicating the number of principal components to be retained; 
    # if NULL, a screeplot of eigenvalues will be displayed and 
    # the user will be asked for a number of retained axes.
    # pca1 <- glPca(vcf_gl, nf = 2)
    
    # # Save PCA data
    write.table(pca1$scores, file = output_data, sep = "\t", quote = FALSE)
    
    # Generate PCA plot
    svg(output_svg, width = 10, height = 8)
    gl.pcoa.plot(pca1, vcf_gl, pop.labels = "pop", xaxis = 1, yaxis = 2, 
                 pt.size = 6, label.size = 2)
    dev.off()
    
    cat(" Completed:", prefix, "\n")
    cat("   - Samples:", length(sample_names), "\n")
    cat("   - Populations:", length(unique(pop_vector)), "\n")
    cat("   - Output:", output_svg, "\n")

    # fast STRUTURE input
    output_str <- paste0(prefix,".str")
    outpath <- paste0("03_fastSTRUCTURE/")

    gl2faststructure(vcf_gl, outfile = output_str, outpath = outpath)
  }, error = function(e) {
    cat("Error processing", prefix, ":", e$message, "\n")
  }
)
}

cat("All processing completed!\n")