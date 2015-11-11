# Clear Workspace
rm(list = ls())

# Necessary libraries
library(caret)
library(XLConnect)  

# Set seed for reproducibility and also set working directory
set.seed(1)

wk = loadWorkbook("CTG.xls") 
data = readWorksheet(wk, sheet="Raw Data")


# First 3 columns are unnecessary: filenames and date
data = data[,-1:-3]


# How many observations in the column are NA 
na_columns_rate = sapply(data, FUN = function(x) sum(is.na(x))/length(x))

# Remove almost fully NA columns
data = data[,na_columns_rate < 0.9]

# Remove NA rows. There are 3 of them
data = data[complete.cases(data),]

# Make all the columns numeric
original_data_types = sapply(data, typeof)
data <- data.frame(lapply(data, FUN = function(x) as.numeric(sub(",", ".", x, fixed = TRUE))))

# Treat all columns with less than 5 unique values as factors
unique_values_count = sapply(data, FUN = function(x) length(unique(x)))
data[,unique_values_count<5] = data.frame(lapply(data[,unique_values_count<5], FUN = function(x) as.factor(as.character(x))))

# Treat CLASS as a factor as well
data$CLASS = as.factor(data$CLASS)

# Finally, remove columns with near-zero variance
data = data[,-nearZeroVar(data, freqCut = 300/1)]

data <- data[-24:-33]

# saving
save(data, file = "dat/data.rda")
