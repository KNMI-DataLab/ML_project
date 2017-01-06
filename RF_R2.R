
                                          #RF


############################################################################################################

### First clear your working environment and install all necessary packages

rm(list=ls())

# Install packages
#install.packages("caret")
#install.packages("caret", dependencies = c("Imports", "Depends", "Suggests"))


### Read in data


# Load train
load("/usr/people/kleingel/Projects/MLProject/Train_3D_noPCA.Rda")

# Load test
load("/usr/people/kleingel/Projects/MLProject/Test_3D_noPCA.Rda")




# Reduce the train set to 1% of its original size 
# 1% equals..
#The_One_Percent <- createDataPartition(Train_set$TRoad, p = 0.01, list = FALSE)
#One_Percent_Train <- Train_set[The_One_Percent, ]

# Split into Train_set and Target_Train
#Target_Train <- One_Percent_Train$TRoad
#Train_set <- subset(One_Percent_Train, select=-c(TRoad))



# Split train set into target and predictors
Target_Train <- Train_set$TRoad
Train_set <- subset(Train_set, select=-c(TRoad))

# Split test set into target and predictors
Target_Test <- Test_set$TRoad
Test_set <- subset(Test_set, select = -c(TRoad))



### Build a random forest 
library(caret)
library(doParallel)
library(parallel)
library(randomForest)

#NOTE: It crashes when you run it on a cluster
#cluster_1<-makeCluster(3)
#registerDoParallel(cluster_1)
#getDoParWorkers()

RF_trainC <- trainControl(method = "repeatedcv", repeats = 5, number = 10, allowParallel = TRUE, 
                          returnData = FALSE)

The_RF <- train(x  = Train_set, 
                y = Target_Train, 
                method = "parRF", 
                trControl = RF_trainC, 
                importance = TRUE, 
                tuneLength = 10)

stopCluster(cluster_1)
registerDoSEQ()






