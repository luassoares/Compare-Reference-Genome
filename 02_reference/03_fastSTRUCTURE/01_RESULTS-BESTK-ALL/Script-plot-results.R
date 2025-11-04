setwd("E:/DART_/05_COMPARE/11_ANALYSIS-NEW/03_fastSTRUCTURE/01_RESULTS-BESTK-ALL/")
library(pophelper)
library(ggplot2)

sfiles <- list.files(path="E:/DART_/05_COMPARE/11_ANALYSIS-NEW/03_fastSTRUCTURE/01_RESULTS-BESTK-ALL/", full.names=T,pattern = "\\.meanQ$")

slist<- readQ(files=sfiles)

missing09 <-slist[,c(3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71)]
plotQ(slist[1],exportpath=getwd())

alt80 <- slist[c(3,7,11,15,19,23)]
grp41 <- slist[c(27,31,35,39,43,47)]
phylo <- slist[c(51,55,63,67,71,59)]

#add indv information
popmap_alt80 <- read.csv("popmap-alt80.txt",header = F)
indmap_alt80 <- read.csv("indmap-alt80.txt", header = F)
indmap_grp41 <- read.csv("indmap-grp41.txt", header = F)
indmap_phylo <- read.csv("indmap-phylo.txt", header = F)

popmap_alt80 <- read.csv("popmap-alt80.txt")
popmap_grp41 <- read.csv("popmap-grp41.txt")
popmap_phylo <- read.csv("popmap-phylo.txt")
# if all runs are equal length, add indlab to all runs
if(length(unique(sapply(alt80,nrow)))==1) alt80 <- lapply(alt80,"rownames<-",indmap_alt80$V1)
if(length(unique(sapply(grp41,nrow)))==1) grp41 <- lapply(grp41,"rownames<-",indmap_grp41$V1)
if(length(unique(sapply(phylo,nrow)))==1) phylo <- lapply(phylo,"rownames<-",indmap_phylo$V1)
# show row names of all runs and all samples
lapply(alt80, rownames)[1:2]

################## Plot miss9 ########################
alt80_plot <- plotQ(slist[c(3,7,11,15,19,23)], imgoutput="join",returnplot=T,exportplot=F,basesize=11)
grp41_plot <- plotQ(slist[c(27,31,35,39,43,47)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,showlegend=T)
phylo_plot <- plotQ(slist[c(51,55,63,67,71,59)], imgoutput="join",returnplot=T,exportplot=F,basesize=11)

print(phylo)

cores_alt <- c("#6aaec6","#3b6a87","#ffe3b2")
cores_grp <- c("#e07342", "#95c073", "#f8961e", "#ff7118","#8a312b")
cores_phy <- c("#5c9ead","#da8e95","#735d78","#e07a5f","#7cb684")

svg("alt80_fastSTRUCTURE_miss9.svg", width = 7, height = 8)
plotQ(alt80[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      sortind="label", clustercol = cores_alt)
dev.off() 

svg("grp41_fastSTRUCTURE_miss9.svg", width = 7, height = 8)
plotQ(grp41[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_grp
      )
dev.off()

svg("phylo_fastSTRUCTURE_miss9.svg", width = 7, height = 8)
plotQ(phylo[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_phy
)
dev.off()

ggsave("phylo_fastSTRUCTURE_miss9.svg", plot = phylo_plot)
ggsave()

################## Plot miss50 ########################
alt80_miss5 <- slist[c(1,5,9,13,17,21)]
grp41_miss5 <- slist[c(25,29,33,37,41,45)]
phylo_miss5 <- slist[c(49,53,57,61,65,69)]

# if all runs are equal length, add indlab to all runs
if(length(unique(sapply(alt80_miss5,nrow)))==1) alt80_miss5 <- lapply(alt80_miss5,"rownames<-",indmap_alt80$V1)
if(length(unique(sapply(grp41_miss5,nrow)))==1) grp41_miss5 <- lapply(grp41_miss5,"rownames<-",indmap_grp41$V1)
if(length(unique(sapply(phylo_miss5,nrow)))==1) phylo_miss5 <- lapply(phylo_miss5,"rownames<-",indmap_phylo$V1)
# show row names of all runs and all samples
lapply(alt80, rownames)[1:2]

svg("alt80_fastSTRUCTURE_miss5.svg", width = 7, height = 8)
plotQ(alt80_miss5[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      sortind="label", clustercol = cores_alt)
dev.off() 

svg("grp41_fastSTRUCTURE_miss5.svg", width = 7, height = 8)
plotQ(grp41_miss5[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_grp
)
dev.off()

svg("phylo_fastSTRUCTURE_miss5.svg", width = 7, height = 8)
plotQ(phylo_miss5[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_phy
)
dev.off()

################## Plot miss80 ########################
alt80_miss8 <- slist[c(2,6,10,14,18,22)]
grp41_miss8 <- slist[c(26,30,34,38,42,46)]
phylo_miss8 <- slist[c(50,54,58,62,66,70)]

# if all runs are equal length, add indlab to all runs
if(length(unique(sapply(alt80_miss8,nrow)))==1) alt80_miss8 <- lapply(alt80_miss8,"rownames<-",indmap_alt80$V1)
if(length(unique(sapply(grp41_miss8,nrow)))==1) grp41_miss8 <- lapply(grp41_miss8,"rownames<-",indmap_grp41$V1)
if(length(unique(sapply(phylo_miss8,nrow)))==1) phylo_miss8 <- lapply(phylo_miss8,"rownames<-",indmap_phylo$V1)
# show row names of all runs and all samples
lapply(alt80, rownames)[1:2]

svg("alt80_fastSTRUCTURE_miss8.svg", width = 7, height = 8)
plotQ(alt80_miss8[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      sortind="label", clustercol = cores_alt)
dev.off() 

svg("grp41_fastSTRUCTURE_miss8.svg", width = 7, height = 8)
plotQ(grp41_miss8[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_grp
)
dev.off()

svg("phylo_fastSTRUCTURE_miss8.svg", width = 7, height = 8)
plotQ(phylo_miss8[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_phy
)
dev.off()


################## Plot miss95 ########################
alt80_miss95 <- slist[c(4,8,12,16,20,24)]
grp41_miss95 <- slist[c(28,32,36,40,44,48)]
phylo_miss95 <- slist[c(52,56,60,64,68,72)]

# if all runs are equal length, add indlab to all runs
if(length(unique(sapply(alt80_miss95,nrow)))==1) alt80_miss95 <- lapply(alt80_miss95,"rownames<-",indmap_alt80$V1)
if(length(unique(sapply(grp41_miss95,nrow)))==1) grp41_miss95 <- lapply(grp41_miss95,"rownames<-",indmap_grp41$V1)
if(length(unique(sapply(phylo_miss95,nrow)))==1) phylo_miss95 <- lapply(phylo_miss95,"rownames<-",indmap_phylo$V1)
# show row names of all runs and all samples
lapply(alt80, rownames)[1:2]

svg("alt80_fastSTRUCTURE_miss95.svg", width = 7, height = 8)
plotQ(alt80_miss95[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      sortind="label", clustercol = cores_alt)
dev.off() 

svg("grp41_fastSTRUCTURE_miss95.svg", width = 7, height = 8)
plotQ(grp41_miss95[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_grp
)
dev.off()

svg("phylo_fastSTRUCTURE_miss95.svg", width = 7, height = 8)
plotQ(phylo_miss95[c(1:6)], imgoutput="join",returnplot=T,exportplot=F,basesize=11,
      showlegend=T, showindlab=T,useindlab=T,
      clustercol = cores_phy
)
dev.off()

