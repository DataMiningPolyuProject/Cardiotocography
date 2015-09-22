# Clear Workspace
rm(list = ls())

# Necessary libraries
library(XLConnect)  

# Set seed for reproducibility and also set working directory
set.seed(1)
setwd("C:/Users/User/Documents/GitHub/Cardiotocography")




wk = loadWorkbook("CTG.xls") 
data = readWorksheet(wk, sheet="Data")

# Column names are given in the first row of dataset. Let's use them.
column_names <- as.character(data[1,])
colnames(data) = column_names
data  = data[-1,]

# How many observations in the column are NA 
na_columns_rate = sapply(data, FUN = function(x) sum(is.na(x))/length(x))

# Remove almost fully NA columns
data = data[,na_columns_rate < 0.4]

# Remove NA rows. There are 3 of them
data = data[complete.cases(data),]


# Make all the columns numeric
original_data_types = sapply(data, typeof)
data <- data.frame(lapply(data, FUN = function(x) as.numeric(sub(",", ".", x, fixed = TRUE))))

# Treat all columns with less than 20 unique values as factors
unique_values_count = sapply(data, FUN = function(x) length(unique(x)))
data[,unique_values_count<21] = data.frame(lapply(data[,unique_values_count<21], FUN = function(x) as.factor(as.character(x))))


# saving
save(data, file = "data.rda")
