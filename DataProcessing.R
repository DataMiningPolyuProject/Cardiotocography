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

load(file="submission_data999.rda")
load(file="train_data999.rda")


# Further partitioning our original training data into training and test sets
inTrain         = createDataPartition(train_data$cuisine, p = 0.8)[[1]]
training        <- train_data[inTrain,]
remainder        <- train_data[-inTrain,]