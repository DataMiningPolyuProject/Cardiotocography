# Clear Workspace
rm(list = ls())

# load libraries
library(corrplot)
library(caret)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/raw_data.rda")

scaledData <- scale(data[,1:22], center = TRUE, scale = TRUE)
corMatrix <- cor(scaledData)

#Plot variable importance
png(filename = "plot/attrCorrelation.png", width = 1000, height = 1000)
corrplot(corMatrix, order="hclust")
dev.off()

# get highly correlated attributes (>70%)
highCorAttrib <- findCorrelation(corMatrix, cutoff=0.7)
highCorAttrib <- sort(highCorAttrib, decreasing = TRUE)

# remove attributes with high correlation
for(i in 1:length(highCorAttrib)) {
  data <- data[-i]
}

# save result
save(data, file = "dat/data.rda")