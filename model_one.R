#random forest model 
source("rf_prepare.R")

#load the packages we need 
#library(kernelshap) 
library(treeshap) #to apply the tree SHAP algorithm
library(ranger) #for the random forest model
library(shapviz) #for the shap visualisation
library(dplyr) #to do some data engineering
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

# check feature importance
importance_ranger = original_model$variable.importance

# look at the values
print(importance_ranger)




####to get a more nuanced view lets plot the feature importance
# Create a data set for the plot
importance_df <- data.frame(Feature = names(importance_ranger), Importance = importance_ranger)

# Plotting 
png("Pfi.png", width = 1600, height = 1200, res = 150)
ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_col() +
  coord_flip() +  # Flip to make it horizontal
  labs(title = "Feature Importance in Random Forest Model",
       x = "Features",
       y = "Importance") +
  theme_minimal()
dev.off()
#median income clearly the most important feature





######
#Test data
#predictions for test data
testPred = predict(original_model, data = test)

#compare with the actual values
actuals <- test$median_house_value
predictions <- testPred$predictions

# calculate MSE
mse_rf = mean((predictions - actuals)^2)

# calculate rmse
test_rmse = sqrt(mse_rf)
test_rmse

# Correct calculation of MAE
#MAE = mean(abs(predictions - actuals))
#MAE
