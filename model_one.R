#random forest model 
source("rf_prepare.R")

#load the packages we need 
#library(kernelshap) 
library(ranger) #for the random forest model
library(ggplot2) # for plotting
#library(pdp) # to visualize partial dependence plots




# Set a random seed so that same sample can be reproduced in future runs
set.seed(21000)

# Randomly sample indices for the training set
ix = sample(nrow(df), 0.7 * nrow(df))

# Create training and testing datasets
train = df[ix, ]
test = df[-ix, ]

#store train and test set as csv to ensure reproducibility
#write.csv(train, "train_data.csv", row.names = FALSE)
#write.csv(test, "test_data.csv", row.names = FALSE)

# Confirm that the total number of rows matches the original dataset
print(nrow(train) + nrow(test) == nrow(df))

# Fitting the random forest model
original_model <- ranger(
  formula = median_house_value ~ ., 
  data = train, 
  importance = "permutation", 
  max.depth = 4, 
  mtry = 4,
  num.trees = 500
)

#check performance (OOB error and so on)
print(original_model)






