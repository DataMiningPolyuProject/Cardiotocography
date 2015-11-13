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
registerDoMC(cores = 4)

# Set seed for reproducibility and also set working directory
set.seed(1)

load(file = "dat/data.rda")
nspCol = length(data)
classCol = length(data) - 1

# Further partitioning our original training data into training and test sets
inTrain         = createDataPartition(data$CLASS, p = 0.8)[[1]]
training        <- data[inTrain,]
remainder        <- data[-inTrain,]



#### MODELS


# Random Forest

# Parameters for caret's train
fitControl <- trainControl(method = "oob")

rf <- train(CLASS~.,
            data = training[-nspCol], 
            method = "rf",
            ntree = 1000,
            trControl = fitControl,
            varImp = TRUE
)

prediction_rf <- predict(rf, newdata = remainder)
print(confusionMatrix(remainder$CLASS, prediction_rf))

save(rf, file = "dat/rfClass.rda")

#Plot variable importance
png(filename = "plot/varImpClass.png", width = 500, height = 500)
varImpPlot(rf$finalModel)
dev.off()
