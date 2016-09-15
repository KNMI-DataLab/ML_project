#############################################################################################################

          # This is the script in which the 6h dataset for the 2nd round of model runs is built


#############################################################################################################

# Empty environment
rm(list=ls())


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
# To get this use the following site: http://www.unixtimestamp.com/ 
# TO DO: CHECK DATE OF THE START OF GMS MEASUREMENTS!!!!!!!





























# Preprocessing (Centering, Scaling, Box-Cox, PCA) ------------------------


library(caret)
xTrans <- preProcess(Predictors_Train[, 1:6], method = c("expoTrans","center","scale"),
                     na.remove = TRUE)

Predictors_Train[, 1:6] <- predict(xTrans, Predictors_Train[ ,1:6])


# Some analysis -----------------------------------------------------------

NearZero_Train <- nearZeroVar(Predictors_Train, names = TRUE, saveMetrics = TRUE)
























