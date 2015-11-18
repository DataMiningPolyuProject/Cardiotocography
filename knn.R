# Clear Workspace
rm(list = ls())

# load libraries
library(caret)
library(doParallel)
registerDoParallel(cores = 8)

# Set seed for reproducibility and also set working directory
set.seed(1)

# seeds for parallel workers
seeds <- vector(mode = "list", length = 6) # length is = (n_repeats*nresampling)+1
for(i in 1:5) seeds[[i]]<- sample.int(n=1000, 22) # ...the number of tuning parameter...
seeds[[6]]<-sample.int(1000, 1) # for the last model

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
nsp_knn_model <- train(NSP~.,
                       data = nsp_training,
                       method = "knn",
                       trControl = fitControl,
                      tuneGrid = expand.grid(k=(2:10))
)
save(nsp_knn_model, file = "model/nsp_knn_model.rda")

nsp_knn_predict <- predict(nsp_knn_model, nsp_testing[,-(length(nsp_testing))])
nsp_knn_verification <- confusionMatrix(nsp_testing$NSP, nsp_knn_predict)
print(nsp_knn_verification)
save(nsp_knn_verification, file = "dat/nsp_knn_verification.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(class_training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_knn_model <- train(CLASS~.,
                        data = class_training,
                        method = "knn",
                        trControl = fitControl,
                        tuneGrid = expand.grid(k=(2:10))
)
save(class_knn_model, file = "model/class_knn_model.rda")

class_knn_predict <- predict(class_knn_model, class_testing[,-(length(class_testing))])
class_knn_verification <- confusionMatrix(class_testing$CLASS, class_knn_predict)
print(class_knn_verification)
save(class_knn_verification, file = "dat/class_knn_verification.rda")