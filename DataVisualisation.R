# Clear Workspace
rm(list = ls())

# Necessary libraries
library(ggplot2)
library(GGally)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "data.rda")

png(filename = "pairs.png", width = 2000, height = 2000)
ggpairs(data[,c(1,2,3,10,15,34,35)], colour='NSP')
dev.off()