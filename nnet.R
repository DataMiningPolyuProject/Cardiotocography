# Clear Workspace
rm(list = ls())

# load libraries
library(caret)
library(doParallel)
registerDoParallel(cores = 8)

# Set seed for reproducibility and also set working directory
set.seed(1)
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
nsp_nnet_model <- train(NSP~.,
                       data = nsp_training,
                       method = "nnet",
                       trControl = fitControl
)

nsp_nnet_predict <- predict(nsp_nnet_model, nsp_testing[,-(length(nsp_testing))])
nsp_nnet_verification <- confusionMatrix(nsp_testing$NSP, nsp_nnet_predict)
print(nsp_nnet_verification)
save(nsp_nnet_verification, file = "dat/nsp_nnet.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(class_training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_nnet_model <- train(CLASS~.,
                        data = class_training,
                        method = "nnet",
                        trControl = fitControl
)

class_nnet_predict <- predict(class_nnet_model, class_testing[,-(length(class_testing))])
class_nnet_verification <- confusionMatrix(class_testing$CLASS, class_nnet_predict)
print(class_nnet_verification)