# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)
library(caret)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/data.rda")

# specify col containing classification result
nsp_col = 18
class_col = 17

# partition dataset: 80% training, 20% testing
data <- data[sample(nrow(data)),]
folds <- cut(seq(1,nrow(data)),breaks=5,labels=FALSE)

# building Naive Bayesian model
nb_nsp_verification <- vector("list", 5)
for(i in 1:5) {
  testIndexes <- which(folds==i, arr.ind=TRUE)
  nsp_testing <- data[testIndexes, -24]
  nsp_training <- data[-testIndexes, -24]
  model <- naiveBayes(NSP~., nsp_training)
  prediction <- predict(model, nsp_testing)
  nb_nsp_verification[[i]] <- confusionMatrix(nsp_testing$NSP, prediction)
}

save(nb_nsp_verification, file = "dat/nsp_naiveBayes.rda")

nb_class_verification <- vector("list", 5)
for(i in 1:5) {
  testIndexes <- which(folds==i, arr.ind=TRUE)
  class_testing <- data[testIndexes, -25]
  class_training <- data[-testIndexes, -25]
  model <- naiveBayes(CLASS~., class_training)
  prediction <- predict(model, class_testing)
  nb_class_verification[[i]] <- confusionMatrix(class_testing$CLASS, prediction)
}

save(nb_class_verification, file = "dat/class_naiveBayes.rda")