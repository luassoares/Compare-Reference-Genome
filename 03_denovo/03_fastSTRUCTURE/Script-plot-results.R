setwd("/Users/luasoares/DOC/COMPARE/07_fastSTRUCTURE")

install.packages("svglite")
library(svglite)
library(pophelper)
library(ggplot2)

sfiles <- list.files(path="BEST_results", full.names=T,pattern = ".meanQ$")


alt_files <- list.files(path="result_alti_90", full.names=TRUE, pattern = "*\\.meanQ$")
grp_files <- list.files(path="result_grp_90",  full.names=TRUE, pattern = "*\\.meanQ$")
phy_files <- list.files(path="result_phylo_90/", full.name=T, pattern = "\\.meanQ$")


alt<- readQ(files=alt_files)
grp<- readQ(files=grp_files)
phy<- readQ(files=phy_files)


#add indv information
popmap_alt80 <- read.csv("../popmap_alti",header = FALSE, sep = '\t')
popmap_grp41 <- read.csv("../popmap_grp",header = FALSE, sep = '\t')
popmap_phylo <- read.csv("../popmap_phylo",header = FALSE, sep = '\t')


# if all runs are equal length, add indlab to all runs
if(length(unique(sapply(alt80,nrow)))==1) alt80 <- lapply(alt80,"rownames<-",popmap_alt80$V1)
if(length(unique(sapply(grp41,nrow)))==1) grp41 <- lapply(grp41,"rownames<-",popmap_grp41$V1)
if(length(unique(sapply(phylo,nrow)))==1) phylo <- lapply(phylo,"rownames<-",popmap_phylo$V1)
# show row names of all runs and all samples
lapply(alt80, rownames)[1:2]


################## Plot miss9 ########################

alt_plots <- plotQ(alt,imgoutput="join",returnplot=T,exportplot=F,basesize=11)
grp_plots <- plotQ(grp,imgoutput="join",returnplot=T,exportplot=F,basesize=11,showlegend=T)
phy_plots <- plotQ(phy,imgoutput="join",returnplot=T,exportplot=F,basesize=11)

alt_plots
grp_plots
phy_plots
print(phylo)

cores_alt <- c("#6aaec6","#3b6a87","#ffe3b2")
cores_grp <- c("#e07342", "#95c073", "#f8961e", "#ff7118","#8a312b")
cores_phy <- c("#5c9ead","#da8e95","#735d78","#e07a5f","#7cb684")




svglite("PLOTS/alt_denovo_fastSTRUCTURE_miss90.svg", width = 7, height = 8)
plotQ(alt[4], returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T
)
dev.off()

svglite("PLOTS/grp_denovo_fastSTRUCTURE_miss90.svg", width = 7, height = 8)
plotQ(grp[6], returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T
)
dev.off()

svglite("PLOTS/phy_denovo_fastSTRUCTURE_miss90.svg", width = 7, height = 8)
plotQ(phy[6], returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T
)
dev.off()

