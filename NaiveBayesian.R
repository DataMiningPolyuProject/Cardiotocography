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
nsp_nb_model <- train(NSP~.,
                       data = nsp_training,
                       method = "nb",
                       preProc = c("center","scale"),
                       trControl = fitControl
)
save(nsp_nb_model, file = "model/nsp_nb_model.rda")

nsp_nb_predict <- predict(nsp_nb_model, nsp_testing[,-(length(nsp_testing))])
nsp_nb_verification <- confusionMatrix(nsp_testing$NSP, nsp_nb_predict)
print(nsp_nb_verification)
save(nsp_nb_verification, file = "dat/nsp_nb_verification.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(class_training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_nb_model <- train(CLASS~.,
                         data = class_training,
                         method = "nb",
                         preProc = c("center","scale"),
                         trControl = fitControl
)
save(class_nb_model, file = "model/class_nb_model.rda")

class_nb_predict <- predict(class_nb_model, class_testing[,-(length(class_testing))])
class_nb_verification <- confusionMatrix(class_testing$CLASS, class_nb_predict)
print(class_nb_verification)
save(class_nb_verification, file = "dat/class_nb_verification.rda")