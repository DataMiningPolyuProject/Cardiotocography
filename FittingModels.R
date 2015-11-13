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
library(doMC)
registerDoMC(cores = 8)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/nsp_training.rda")
load(file = "dat/nsp_testing.rda")
load(file = "dat/class_training.rda")
load(file = "dat/class_testing.rda")

# Random Forest

# Parameters for caret's train
fitControl <- trainControl(method = "oob")

rf <- train(NSP~.,
             data = nsp_training, 
             method = "rf",
             ntree = 1000,
             trControl = fitControl,
             varImp = TRUE
)

prediction_rf <- predict(rf, nsp_testing[,-(length(nsp_testing))])
print(confusionMatrix(nsp_testing$NSP, prediction_rf))

save(rf, file = "dat/rf.rda")

#Plot variable importance
png(filename = "plot/varImpNSP.png", width = 500, height = 500)
varImpPlot(rf$finalModel)
dev.off()
