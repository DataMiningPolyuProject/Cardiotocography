# Clear Workspace
rm(list = ls())

# load libraries
library(e1071)

# Set seed for reproducibility and also set working directory
set.seed(1)
load(file = "dat/data.rda")

# partition dataset: 80% training, 20% testing
sub <- sample(nrow(data), nrow(data)*0.8)

nsp_training <- data[sub, -24]
nsp_testing <- data[-sub, -24]

class_training <- data[sub, -25]
class_testing <- data[-sub, -25]

# building Naive Bayesian model
model <- naiveBayes(NSP~., nsp_training)
prediction <- predict(model, nsp_testing)
nsp_verification <- confusionMatrix(nsp_testing$NSP, prediction)
save(nsp_verification, file = "dat/nsp_naiveBayes.rda")

model <- naiveBayes(CLASS~., class_training)
prediction <- predict(model, class_testing)
class_verification <- confusionMatrix(class_testing$CLASS, prediction)
save(class_verification, file = "dat/class_naiveBayes.rda")