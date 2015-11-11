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

#########################################
## NSP classification ###################
#########################################

# predict NSP
svm_nsp_verification <- vector("list", 5)
for(i in 1:5) {
  testIndexes <- which(folds==i, arr.ind=TRUE)
  nsp_testing <- data[testIndexes, -class_col]
  nsp_training <- data[-testIndexes, -class_col]
  nsp_param <- tune(svm, NSP~., data=nsp_training, ranges = list(gama=2^(-1:1), cost=2^(2:4)), tunecontrol=tune.control(sampling="fix"))
  svm_model <- svm(NSP~., nsp_training, gama=nsp_param$best.parameters$gama, cost=nsp_param$best.parameters$cost)
  svm_model <- svm(NSP~., nsp_training)
  svm_predict <- predict(svm_model, nsp_testing)
  svm_nsp_verification[[i]] <- confusionMatrix(nsp_testing$NSP, svm_predict)
}

save(svm_nsp_verification, file = "dat/nsp_svm.rda")

#########################################
## CLASS classification #################
#########################################

# predict CLASS
svm_class_verification <- vector("list", 5)
for(i in 1:5) {
  testIndexes <- which(folds==i, arr.ind=TRUE)
  class_testing <- data[testIndexes, -nsp_col]
  class_training <- data[-testIndexes, -nsp_col]
  class_param <- tune(svm, CLASS~., data=class_training, ranges = list(gama=2^(-1:1), cost=2^(2:4)), tunecontrol=tune.control(sampling="fix"))
  svm_model <- svm(CLASS~., class_training, cost=class_param$best.parameters$cost, gama=class_param$best.parameters$gama)
  svm_predict <- predict(svm_model, class_testing)
  svm_class_verification[[i]] <- confusionMatrix(class_testing$CLASS, svm_predict)
}

save(svm_class_verification, file = "dat/class_svm.rda")