# Clear Workspace
rm(list = ls())

# load libraries
library(corrplot)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/data.rda")

scaled_data <- scale(data[,1:22], center = TRUE, scale = TRUE)
cor_mat <- cor(scaled_data)

#Plot variable importance
png(filename = "plot/attrCorrelation.png", width = 1000, height = 1000)
corrplot(cor_mat, order="hclust")
dev.off()