# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)
library(caret)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/data.rda")
nspCol = length(data)
classCol = length(data) - 1
print(sprintf("NSP: %g, class: %g", nspCol, classCol))

# NSP classification
inTrain <- createDataPartition(data$NSP, p=0.8)[[1]]
training <- data[inTrain, ]
testing <- data[-inTrain, ]

fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(training$NSP, k=5, times=1)
)

#Define Equation for Models
nsp_nb_model <- train(NSP~.,
                       data = training[,-classCol],
                       method = "nb",
                       preProc = c("center","scale"),
                       trControl = fitControl
)

nsp_nb_predict <- predict(nsp_nb_model, testing[,-classCol])
nsp_nb_verification <- confusionMatrix(testing$NSP, nsp_nb_predict)
print(nsp_nb_verification)
save(nsp_nb_verification, file = "dat/nsp_nb.rda")

# class classification
fitControl <- trainControl(method = "repeatedCV", 
                           number = 5, 
                           repeats = 1,
                           index = createMultiFolds(training$CLASS, k=5, times=1)
)

#Define Equation for Models
class_nb_model <- train(CLASS~.,
                         data = training[, -nspCol],
                         method = "nb",
                         preProc = c("center","scale"),
                         trControl = fitControl
)

class_nb_predict <- predict(class_nb_model, testing[, -nspCol])
class_nb_verification <- confusionMatrix(testing$CLASS, class_nb_predict)
print(class_nb_verification)