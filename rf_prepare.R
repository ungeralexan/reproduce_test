#1) prepare the data for the "model_one" file
#and for the "visualize_improve" file


#clear the workspace
rm(list=ls())

#necessary libraries for the feature engineering
library(tidyverse)
library(dplyr)
library(reshape2)
library(caret)
#read in the data set from kaggle : https://www.kaggle.com/datasets/camnugent/california-housing-prices 
#or from my github page
house = read.csv("housing.csv")

#first look at the data
head(house)



#check for missing observations
sum(is.na(house))
#there are 207 observations where we detect missing entries 


#lets see where those observations are missing
countNAs <- function(data) {
  na_count <- sapply(data, function(y) sum(length(which(is.na(y)))))
  return(na_count)
}


na_counts <- countNAs(house)
print(na_counts)


#omit those missing entries for the total bedrooms variable as the data set is large enough
house = na.omit(house)

#check the distribution in the data 
summary(house)
#Income reaches form 0.5-15
#Median house value has some outliers


#######################
#lets extract the feature visualization later
ocean_feature = house$ocean_proximity
ocean_feature = as.data.frame(ocean_feature) #store it as frame
drop_for_distributions =  c('ocean_proximity')
distributions = house[ , !(names(house) %in% drop_for_distributions)]
distributions = as.data.frame(distributions)
str(distributions)
#######################

#######
# One-Hot-Encoding the 'ocean_proximity' variable
house$ocean_proximity <- as.factor(house$ocean_proximity)
dummies <- dummyVars(~ ocean_proximity, data = house)
house_encoded <- predict(dummies, newdata = house)
house_encoded <- as.data.frame(house_encoded)

# Combine the encoded variables with the numerical variables
house <- cbind(house, house_encoded)
drop_vector <- c('ocean_proximity')
house <- house[ , !(names(house) %in% drop_vector)]
############




#now lets change our variables (to reduce correlations see visualizing)

#now lets face new bedroom variables 
house$mean_population = house$population/house$households # the average population per household
house$mean_bedrooms = house$total_bedrooms/house$households #average number of bedrooms per household
house$mean_rooms = house$total_rooms/house$households # the average number of rooms per household 


#drop the old features
drop_again = c('total_bedrooms', 'total_rooms', 'population')

house = house[ , !(names(house) %in% drop_again)] # updates the housing dataframe to keep only the columns not listed in drops.

head(house) 



##############################
#for the visualization later
drops_3 = c('median_house_value')
house_num =  house[ , !(names(house) %in% drops_3)] #updates housing_num to include only the columns not listed in drops_1. This leaves you with a dataset of purely numerical features without the target variable.

head(house_num)
###############################


# Dataframe is the dataset that is gonna be used throughout the analysis
df = house 


new_column_names <- c("lessoneOcean", "inland","island", "nearBay", "nearOcean")

colnames(df)[7:11] <- new_column_names


# Specify the desired column order based on actual column names
desired_order <- c('nearBay', 'lessoneOcean', 'inland', 'nearOcean',
                   'island', 'longitude', 'latitude', 'housing_median_age', 'households', 'median_income',
                   'mean_population', 'mean_bedrooms', 'mean_rooms', 'median_house_value')

df <- df[, desired_order]