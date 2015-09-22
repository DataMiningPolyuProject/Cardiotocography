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



# Set seed for reproducibility and also set working directory
set.seed(1)
setwd("C:/Users/User/Documents/GitHub/Cardiotocography")

load(file = "data.rda")


# Further partitioning our original training data into training and test sets
inTrain         = createDataPartition(data$NSP, p = 0.8)[[1]]
training        <- data[inTrain,]
remainder        <- data[-inTrain,]



#### MODELS


# Random Forest

# Parameters for caret's train
fitControl <- trainControl(method = "oob")

rf <- train(NSP~.,
             data = training[-38], 
             method = "rf",
             ntree = 1000,
             trControl = fitControl,
             varImp = TRUE
)

prediction_rf <- predict(rf, newdata = remainder)
confusionMatrix(remainder$NSP, prediction_rf)

save(rf, file = "rf.rda")
