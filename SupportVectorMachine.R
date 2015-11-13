# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)
library(caret)
library(doParallel)
registerDoParallel(cores = 4)

# Set seed for reproducibility and also set working directory
set.seed(123)
load(file = "dat/nsp_training.rda")
load(file = "dat/nsp_testing.rda")
load(file = "dat/class_training.rda")
load(file = "dat/class_testing.rda")

fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(nsp_training$NSP, k=5, times=1)
)

#Define Equation for Models
nsp_svm_model <- train(NSP~.,
                       data = nsp_training,
                       method = "svmLinear",
                       preProc = c("center","scale"),
                       trControl = fitControl,
                       tuneGrid = expand.grid(C= 2^c(0:5))
)
save(nsp_svm_model, "model/nsp_svm_model.rda")

nsp_svm_predict <- predict(nsp_svm_model, nsp_testing[,-(length(nsp_testing))])
nsp_svm_verification <- confusionMatrix(nsp_testing$NSP, nsp_svm_predict)
print(nsp_svm_verification)
save(nsp_svm_verification, file = "dat/nsp_svm_verification.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(class_training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_svm_model <- train(CLASS~.,
                       data = class_training,
                       method = "svmLinear",
                       preProc = c("center","scale"),
                       trControl = fitControl,
                       tuneGrid = expand.grid(C= 2^c(0:5))
)
save(class_svm_model, "model/class_svm_model.rda")

class_svm_predict <- predict(class_svm_model, class_testing[,-(length(class_testing))])
class_svm_verification <- confusionMatrix(class_testing$CLASS, class_svm_predict)
print(class_svm_verification)
save(class_svm_verification, "model/class_svm_verification.rda")