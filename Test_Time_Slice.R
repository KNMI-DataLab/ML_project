#####################################################################################
#                                                                                   #
#                                                                                   #
#         Here I test the function create Time Slices                               #
#                                                                                   #
#                                                                                   #
#####################################################################################


# First empty environment and install relevant packages
rm(list=ls())

#install.packages("caret")
#install.packages("pls")
#install.packages("pbkrtest")


# call libraries and dataset
library(caret)
library(ggplot2)
library(pls)

data(economics)

# Make TimeSlices index
timeSlices <- createTimeSlices(1:nrow(economics), initialWindow = 36, horizon = 12, fixedWindow = TRUE)

# Inspect time series data
str(timeSlices,max.level = 1)

# Seperate train and test slices
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]

# Now train a pls model on the economics data with function (unemployment ~ personal 
# consumption expenditures + population + personal savings rate)
# You train this model on the first slice only
plsFitTime <- train(unemploy ~ pce + pop + psavert,
                    data = economics[trainSlices[[1]],],
                    method = "pls",
                    preProc = c("center", "scale"))

# Predict based on the first test slice 
pred <- predict(plsFitTime,economics[testSlices[[1]],])

# Plot target variable and predicted target variable for first test slice  
true <- economics$unemploy[testSlices[[1]]]

plot(true, col = "red", ylab = "true (red) , pred (blue)", ylim = range(c(pred,true)))
points(pred, col = "blue") 


# To do this for all the time slices: 
# (CODE RUNS FOR VERY LONG TIME)
for(i in 1:length(trainSlices)){
  plsFitTime <- train(unemploy ~ pce + pop + psavert,
                      data = economics[trainSlices[[i]],],
                      method = "pls",
                      preProc = c("center", "scale"))
  pred <- predict(plsFitTime,economics[testSlices[[i]],])
  
  
  true <- economics$unemploy[testSlices[[i]]]
  plot(true, col = "red", ylab = "true (red) , pred (blue)", 
       main = i, ylim = range(c(pred,true)))
  points(pred, col = "blue") 
}

# 





