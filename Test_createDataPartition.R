# First empty environment and install relevant packages
rm(list=ls())

# call libraries 
library(caret)

# import data
load("/usr/people/kleingel/Projects/MLProject/Data_10min.Rda")

# test the createDataPartition function with 75% training, 25% test
Data_Partition <- createDataPartition(Data_10min$TEMP, p = 0.75, list = FALSE)

Training <- Data_10min[Data_Partition, ]
Testing <- Data_10min[-(Data_Partition), ]

# Check the distribution of TEMP within the original dataset and compare to training/test dataset
par(mfrow=c(1,3))

hist(Data_10min$TEMP)
hist(Training$TEMP)
hist(Testing$TEMP)

# Check the distribution of some other variables
PlotCol <- c(1,4,5, 6)

for (i in (PlotCol)){
  par(mfrow=c(1,3))
  print(i)
  hist(Data_10min[, i], freq = FALSE, xlab = colnames(Data_10min)[i], main = paste("GMS Data", colnames(Data_10min)[i]))
  hist(Training[, i], freq = FALSE, xlab = colnames(Training)[i], main = paste("Training", colnames(Data_10min)[i]))
  hist(Testing[, i], freq = FALSE, xlab = colnames(Testing)[i], main = paste("Testing", colnames(Data_10min)[i]))
}

# Relative proportion of sensors per set 
prop.table(table(Data_10min$SENSOR))
prop.table(table(Training$SENSOR))
prop.table(table(Testing$SENSOR))



