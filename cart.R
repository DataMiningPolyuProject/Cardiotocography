# Clear Workspace
rm(list = ls())

# load libraries
library(caret)
library(doParallel)
registerDoParallel(cores = 4)

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
nsp_cart_model <- train(NSP~.,
                       data = nsp_training,
                       model = "cart",
                       trControl = fitControl
)
save(nsp_cart_model, file = "model/nsp_cart_model.rda")

nsp_cart_predict <- predict(nsp_cart_model, nsp_testing[,-(length(nsp_testing))])
nsp_cart_verification <- confusionMatrix(nsp_testing$NSP, nsp_cart_predict)
print(nsp_cart_verification)
save(nsp_cart_verification, file = "dat/nsp_cart_verification.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(class_training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_cart_model <- train(CLASS~.,
                         data = class_training,
                         model = "cart",
                         trControl = fitControl
)
save(class_cart_model, file = "model/class_cart_model.rda")

class_cart_predict <- predict(class_cart_model, class_testing[,-(length(class_testing))])
class_cart_verification <- confusionMatrix(class_testing$CLASS, class_cart_predict)
print(class_cart_verification)
save(class_cart_verification, file = "dat/class_cart_verification.rda")