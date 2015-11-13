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

#### MODELS


# Random Forest

# Parameters for caret's train
fitControl <- trainControl(method = "oob")

rf <- train(CLASS~.,
            data = class_training, 
            method = "rf",
            ntree = 1000,
            trControl = fitControl,
            varImp = TRUE
)

prediction_rf <- predict(rf, newdata = class_testing[,-(length(class_testing))])
print(confusionMatrix(class_testing$CLASS, prediction_rf))

save(rf, file = "dat/rfClass.rda")

#Plot variable importance
png(filename = "plot/varImpClass.png", width = 500, height = 500)
varImpPlot(rf$finalModel)
dev.off()
