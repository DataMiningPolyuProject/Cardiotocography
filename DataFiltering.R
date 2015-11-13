# Clear Workspace
rm(list = ls())

# load libraries
library(corrplot)
library(caret)
#library(doParallel)
#registerDoParallel(cores = 4)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/raw_training.rda")
load(file = "dat/raw_testing.rda")

# seperate data sets
nsp_raw_training <- training[,-(length(training)-1)]
nsp_raw_testing <- testing[,-(length(testing)-1)]
class_raw_training <- training[,-(length(training))]
class_raw_testing <- testing[,-(length(testing))]

save(nsp_raw_training, file = "dat/nsp_raw_training.rda")
save(nsp_raw_testing, file = "dat/nsp_raw_testing.rda")
save(class_raw_training, file = "dat/class_raw_training.rda")
save(class_raw_testing, file = "dat/class_raw_testing.rda")

#### correlation between attributes ###

### correlation filtering ###
scaledData <- scale(nsp_raw_training[,1:22], center = TRUE, scale = TRUE)
corMatrix <- cor(scaledData)

#Plot variable importance
png(filename = "plot/attrCorrelation.png", width = 1000, height = 1000)
corrplot(corMatrix, order="hclust")
dev.off()

# get highly correlated attributes (>70%)
highCorAttrib <- findCorrelation(corMatrix, cutoff=0.95)
print(sort(highCorAttrib, decreasing = TRUE))

# remove attributes with high correlation
nsp_training <- nsp_raw_training[,-highCorAttrib]
nsp_testing <- nsp_raw_testing[,-highCorAttrib]
class_training <- class_raw_training[,-highCorAttrib]
class_testing <- class_raw_testing[,-highCorAttrib]

scaledData <- scale(nsp_raw_training[,1:22][,-highCorAttrib], center = TRUE, scale = TRUE)
corMatrix <- cor(scaledData)

# plot cor matrix heatmap with high corr predictors removed
png(filename = "plot/attrCorrelationFiltered.png", width = 1000, height = 1000)
corrplot(corMatrix, order="hclust")
dev.off()

### RFE filtering ###
# feature importance
nspFeatures <- rfe(nsp_training[,1:(length(nsp_training)-1)], 
                   nsp_training$NSP, 
                   size=c(1:(length(nsp_training)-1)),
                   rfeControl=rfeControl(functions=nbFuncs, method="repeatedcv", number = 5)
)

classFeatures <- rfe(class_training[,1:(length(class_training)-1)],
                     class_training$CLASS,
                     size=c(1:(length(class_training)-1)),
                     rfeControl=rfeControl(functions=nbFuncs, method="repeatedcv", number=5)
)

l <- predictors(nspFeatures)
l[length(l)+1] = "NSP"
m <- predictors(classFeatures)
m[length(m)+1] = "CLASS"

nsp_training <- nsp_training[,l]
nsp_testing <- nsp_testing[,l]
class_training <- class_training[,m]
class_testing <- class_testing[,m]

print(predictors(nspFeatures))
png(filename = "plot/nsp_rfe.png", width = 1000, height = 1000)
plot(nspFeatures, type=c("g", "o"))
dev.off()

print(predictors(classFeatures))
png(filename = "plot/class_rfe.png", width = 1000, height = 1000)
plot(classFeatures, type=c("g", "o"))
dev.off()

# save result
save(nspFeatures, file = "dat/nsp_features.rda")
save(classFeatures, file = "dat/class_features.rda")

save(nsp_training, file = "dat/nsp_training.rda")
save(nsp_testing, file = "dat/nsp_testing.rda")

save(class_training, file = "dat/class_training.rda")
save(class_testing, file = "dat/class_testing.rda")