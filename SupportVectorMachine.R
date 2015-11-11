# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "data.rda")

# partition dataset: 80% training, 20% testing
sub <- sample(nrow(data), nrow(data)*0.8)

nsp_training <- data[sub, -24]
nsp_testing <- data[-sub, -24]

class_training <- data[sub, -25]
class_testing <- data[-sub, -25]

# predict NSP
svm_model <- svm(NSP~., nsp_training)
svm_predict <- predict(svm_model, nsp_testing)
nsp_verification <- confusionMatrix(nsp_testing$NSP, svm_predict)
save(nsp_verification, file = "nsp_svm.rda")

# predict CLASS
svm_model <- svm(CLASS~., class_training)
svm_predict <- predict(svm_model, class_testing)
class_verification <- confusionMatrix(class_testing$CLASS, svm_predict)
save(class_verification, file = "class_svm.rda")