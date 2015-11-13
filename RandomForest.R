# Clear Workspace
rm(list = ls())

# Necessary libraries
library(caret)
library(plyr)
library(Metrics)
library(mice)
library(ggplot2)
library(RColorBrewer)
library(rms)
library(doParallel)
registerDoParallel(cores = 4)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/nsp_training.rda")
load(file = "dat/nsp_testing.rda")
load(file = "dat/class_training.rda")
load(file = "dat/class_testing.rda")

# Random Forest

#### NSP classification ####
# Parameters for caret's train
fitControl <- trainControl(method = "oob")

nsp_rf_model <- train(NSP~.,
             data = nsp_training, 
             method = "rf",
             ntree = 1000,
             trControl = fitControl,
             varImp = TRUE
)
save(nsp_rf_model, file = "model/nsp_rf_model.rda")

prediction_rf <- predict(nsp_rf_model, nsp_testing[,-(length(nsp_testing))])
nsp_rf_verification <- confusionMatrix(nsp_testing$NSP, prediction_rf)
save(nsp_rf_verification, file = "dat/nsp_rf_verification.rda")
print(nsp_rf_verification)

#Plot variable importance
png(filename = "plot/varImpNSP.png", width = 500, height = 500)
varImpPlot(nsp_rf_model$finalModel)
dev.off()

#### CLASS classification ####


# Random Forest

# Parameters for caret's train
fitControl <- trainControl(method = "oob")

class_rf_model <- train(CLASS~.,
            data = class_training, 
            method = "rf",
            ntree = 1000,
            trControl = fitControl,
            varImp = TRUE
)
save(class_rf_model, file = "model/class_rf_model.rda")

prediction_rf <- predict(class_rf_model, newdata = class_testing[,-(length(class_testing))])
class_rf_verification <- confusionMatrix(class_testing$CLASS, prediction_rf)
save(class_rf_verification, file = "dat/class_rf_verification.rda")
print(class_rf_verification)

#Plot variable importance
png(filename = "plot/varImpClass.png", width = 500, height = 500)
varImpPlot(class_rf_model$finalModel)
dev.off()
