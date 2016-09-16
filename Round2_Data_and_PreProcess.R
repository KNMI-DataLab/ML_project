#############################################################################################################

          # This is the script in which the 6h dataset for the 2nd round of model runs is built


#############################################################################################################

# Empty environment
rm(list=ls())

# Install packages
# install.packages("corrplot")
# install.packages("GGally")

# Read in the environmental dataset
load("F:/KNMI/MLProject/Env_Data.Rda")



# Build the training set  -------------------------------------------------

# Read in the 6h GMS dataset and remove al data which is not labeled as 'valid' 
load("F:/KNMI/GMS_6h.Rda")
GMS_6h <- GMS_6h[GMS_6h$QUALITY == "valid", ]

# Drop the quality column in the 6h GMS dataset
GMS_6h <- GMS_6h[ ,-7]

# Merge 6h GMS data and environmental dataset
Data_6h <-merge(GMS_6h,Env_Data_4,by.x=c("LOCATION","SENSOR"),by.y=c("MISD","SENSOR"))

# Split into input (predictors) and output (target variable)
# Output
Target_Train <- Data_6h$TEMP

# Input 
# Drop LOCATION/SENSOR/TIMESTAMP en TEMP
Data_6h <- Data_6h[ ,-(1:3)]
Data_6h <- Data_6h[ ,-3]
Predictors_Train <- Data_6h

 

# Build the test set  -----------------------------------------------------

# Read in the 1.5h GMS dataset and remove all data which is not labeled as 'valid' 
load("F:/KNMI/MLProject/GMS_1.5h.Rda")
GMS_1.5h <- GMS_1.5h[GMS_1.5h$QUALITY == "valid", ]
GMS_1.5h <- GMS_1.5h[ ,-7]

Data_1.5h <-merge(GMS_1.5h,Env_Data_4,by.x=c("LOCATION","SENSOR"),by.y=c("MISD","SENSOR"))

# Split into input (predictors) and output (target variable)
# Output
Target_Test <- Data_1.5h$TEMP

# Input 
# Drop LOCATION/SENSOR/TIMESTAMP en TEMP
Data_1.5h <- Data_1.5h[ ,-(1:3)]
Data_1.5h <- Data_1.5h[ ,-3]
Predictors_Test <- Data_1.5h



# Change data format ------------------------------------------------------
# To prepare the train/test data for the ML algorithms we need to run some pre-processing code
# This code centers, scales, resolves skewness with BoxCox and performs a PCA
# However, as BoxCox cannot be applied to negative/0 values it is necessary to first alter the data formats so that the data
# contains no negative/0 values
# A simple trick is to put temperatures in K and heighten the ALT to give instead of m, m + 10

# First, we test how the variables are distributed in the train set
# Make a vector containing all continuous predictors (: all predictors that are not dummies)
Cont_vars <- colnames(Predictors_Train)[1:6]

# Get a summary for each variable in the train data
for (i in seq_along(Cont_vars)){
  print(Cont_vars[i])
  print(summary(Predictors_Train[ , i]))
}

summary(Target_Train)


# Get a summary for each variable in the test data
for (i in seq_along(Cont_vars)){
  print(Cont_vars[i])
  print(summary(Predictors_Test[ , i]))
}

summary(Target_Test) 

# It would be usefull to subtract the nr of seconds since 1970 at the start of the GMS data from the Unix_Time column
# TO DO: CHECK DATE OF THE START OF GMS MEASUREMENTS!!!!!!!
# According to Met_conditions script: 2009-03-01

sStart <- as.numeric(as.POSIXct("2009-03-01 00:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "GMT"))
Predictors_Train$Unix_Time <- (Predictors_Train$Unix_Time - sStart)
Predictors_Test$Unix_Time <- (Predictors_Test$Unix_Time - sStart)



# Add 10m to ALT for train and test data
Predictors_Train$ALT <- Predictors_Train$ALT + 10
Predictors_Test$ALT <- Predictors_Test$ALT + 10

# Convert TD, TL in Predictors to Kelvin

# For train
Predictors_Train$TL <- Predictors_Train$TL + 273.15
Predictors_Train$TD <- Predictors_Train$TL + 273.15

# For test
Predictors_Test$TL <- Predictors_Test$TL + 273.15
Predictors_Test$TD <- Predictors_Test$TD + 273.15

# Convert target variables to Kelvin
Target_Train <- Target_Train + 273.15
Target_Test <- Target_Test + 273.15



# Data analysis before preProcessing --------------------------------------

# Multicollinearity can slow down/stop some ML algorithms when building a model
# To resolve any multicollinearity we later run a PCA 
# Here we examine the correlation between predictors BEFORE a PCA is run
# Ideally, you would like to make a scatterplot of how all the predictors are correlated as well as a correlation plot

library(corrplot)

# TRAIN

# Build a correlation matrix of all predictors
# To deal with the NA values in the TL and TD data set the use parameter to "complete.obs"
# TO DO: CHECK WHERE NA VALUES ORIGINATE, IS THIS CORRECT?

# The dummy vars show high correlations: CHECK FOR DUMMY VARIABLE TRAP
corTrain <- cor(Predictors_Train, use = "complete.obs")
corrplot(corTrain, method = "circle")

# Build a correlation matrix without the dummy vars
# There are some interesting patterns:
# TL and TD are perfectly correlated (cor = 1)
# The air (and dew point) temperature are positively correlated with time (which is unsuprising as temperature steadily 
# increases over the day because the sun is rising) and latitude
# ALTitude is negatively correlated with air temperature and latitude
# Lon and Lat are weakly positively correlated

corTrain_2 <- cor(Predictors_Train[, 1:6], use = "complete.obs")
corrplot(corTrain_2, method = "number")


# TEST
# Build a correlation matrix of all predictors
corTest <- cor(Predictors_Test, use = "complete.obs")
corrplot(corTest, method = "circle")

# Build a correlation matrix without the dummy vars
# The test set shows some different patterns compared to the train set:
# TL and TD are almost uncorrelated
# TD and LAT are NEGATIVELY correlated whereas
# TL and LAT are weakly positively correlated
# The relationship between TL and time remains approximately the same, because this time slice is also taken from the same
# moment of the day

# DOES THIS MEAN THAT WE HAVE TO CHOOSE ANOTHER TEST SET?
corTest_2 <- cor(Predictors_Test[ , 1:6], use = "complete.obs")
corrplot(corTest_2, method = "number")

# These scatterplots take a long time to run (between 5-10 min) and are therefore uncommented. Plots have been saved.
# You cannot run for all variables because R will crash hopelessly and delete all the code you wrote.
library(GGally)
# ggpairs(data = Predictors_Train, columns = c("TL", "TD", "Unix_Time", "LAT", "LON", "ALT"))
# pairs(~ TL + TD + Unix_Time + LAT + LON + ALT, data = Predictors_Train)






# Preprocessing (Centering, Scaling, Box-Cox, PCA) ------------------------
# First we make some scatterplots to view the relationships between the predictors, focussing especially on ALT
Cont_vars <- colnames(Predictors_Train)[1:6]

# Get a summary for each variable in the train data
for (i in seq_along(Cont_vars)){
  
  plot(Predictors_Train[ , i], ylab = Cont_vars[i])
}

plot(Predictors_Train$LON, Predictors_Train$ALT)

# Next we perform the BoxCox
library(caret)
xTrans <- preProcess(Predictors_Train[, 1:6], method = c("BoxCox"),
                     na.remove = TRUE)

Predictors_Train[, 1:6] <- predict(xTrans, Predictors_Train[ ,1:6])

# The BoxCox worked!!!!
plot(Predictors_Train$LON, Predictors_Train$ALT)

# However, somehow the time column has been changed to 0.5?????
# Maybe this problem occurs because the change in time is small compared to the size of the time variable?
# This may make Unix_Time seem like a constant, when it is not actually a constant.
# How to fix this?
for (i in seq_along(Cont_vars)){
  
  plot(Predictors_Train[ , i], ylab = Cont_vars[i])
}

# Test patterns in the test set
for (i in seq_along(Cont_vars)){
    plot(Predictors_Test[ , i], ylab = Cont_vars[i])
}

plot(Predictors_Test$LON, Predictors_Test$ALT)

# Apply the transform to the test set
Predictors_Test[, 1:6] <- predict(xTrans, Predictors_Test[ ,1:6])

# Effect of the transform
for (i in seq_along(Cont_vars)){
  plot(Predictors_Test[ , i], ylab = Cont_vars[i])
}


# Some analysis -----------------------------------------------------------

NearZero_Train <- nearZeroVar(Predictors_Train, names = TRUE, saveMetrics = TRUE)
























