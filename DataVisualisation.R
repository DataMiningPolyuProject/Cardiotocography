# Clear Workspace
rm(list = ls())

# Necessary libraries
library(ggplot2)
library(GGally)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/raw_data.rda")


png(filename = "pairs.png", width = 2000, height = 2000)
ggpairs(raw_data[,c(1,2,3,10,15,21,22)], colour='A')
dev.off()



ggplot(raw_data, aes(x = b, y = FM)) + 
        geom_line(colour = I("royalblue3")) 
