# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "data.rda")

# partition dataset: 80% training, 20% testing
sub <- sample(nrow(data), nrow(data)*0.8)

nsp_training <- data[sub, -34]
nsp_testing <- data[-sub, -34]

class_training <- data[sub, -35]
class_testing <- data[-sub, -35]

# building Naive Bayesian model
model <- naiveBayes(NSP~., nsp_training)
prediction <- predict(model, nsp_testing)
nsp_verification <- confusionMatrix(nsp_testing$NSP, prediction)
save(nsp_verification, file = "nsp_naiveBayes.rda")

model <- naiveBayes(CLASS~., class_training)
prediction <- predict(model, class_testing)
class_verification <- confusionMatrix(class_testing$CLASS, prediction)
save(class_verification, file = "class_naiveBayes.rda")