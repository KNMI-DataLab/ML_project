
#First clear your working environment and install all necessary packages
rm(list=ls())
#install.packages("caret")
#install.packages("GGally")
 

#Now load in the test and train sets 
load("/usr/people/kleingel/Projects/MLProject/Train_BIG_noPCA_LOC.Rda")
load("/usr/people/kleingel/Projects/MLProject/Test_BIG_noPCA_LOC.Rda")

# The test and train sets are too big to easily plot the relationships between variables
# For example, plotting the relationship between two variables in the train set takes up 10 GB of RAM
# plot(x= Train_set$DOY_Days, y= Train_set$TRoad)

# Ideally we would like to plot the relationships between all predictors and the target variable to see if 
# any of the relationships are nonlinear 

# To reduce the size of the dataset we take the mean of each of the predictors per station number/LOCATION
Train_MeanLoc <- aggregate(Train_set, by = list(Train_set$LOCATION), mean)

# Next, we make a scatterplot matrix with the featureplot function from the caret package
# The ggpairs function from the GGally package is also really nice, but it plots too much 
library(caret)
library(GGally)
featurePlot(x = Train_MeanLoc, y = Train_MeanLoc$TRoad)



# ALT is nonlinear, TD & TL seem mostly linear. 
# There seems to be one large outlier at station 813
summary(Train_MeanLoc$TL)
which(Train_MeanLoc$TL == max(Train_MeanLoc$TL))

# According to the decision tree only 10 predictors really matter, plot these
# This plot takes a long time (>10 minutes) and 10 GB RAM
Train_Matter <- cbind(Train_set[, 2:8], Train_set$Klei, Train_set$Zand, Train_set$Water, Train_set$LOCATION, Train_set$TRoad)
colnames(Train_Matter)[8:12] <- c("Klei", "Zand", "Water", "LOCATION","TRoad")
#featurePlot(Train_Matter[, 1:10], Train_Matter$TRoad)




# Next, we make individual plots of the variables that seem to have a non-linear relationship with temperature
#plot(Train_set$ALT, Train_set$TRoad)
#plot(Train_MeanLoc$ALT, Train_MeanLoc$TRoad)
#plot(Train_set$TL, Train_set$TRoad)
#plot(x = Train_set$HOD_Days, y = Train_set$TRoad)

# The downside of plots with so many points is that the relationship between the variables is less visible.
# You can change the opacity of the points and/or add a smooth to visualise the relationship 
Train_MatterMean <- aggregate(Train_Matter, by = list(Train_Matter$LOCATION), mean)
Train_MatterHOD  <- aggregate(Train_Matter, by = list(Train_Matter$HOD_Days), mean)
Train_MatterDOY  <- aggregate(Train_Matter, by = list(Train_Matter$DOY_Days), mean)

featurePlot(Train_MatterMean[1:11], Train_MatterMean$TRoad)
featurePlot(Train_MatterHOD[1:11], Train_MatterHOD$TRoad)

# NON LINEAR Time
plot(Train_MatterHOD$HOD_Days, Train_MatterHOD$TRoad)

ggplot(Train_MatterHOD, aes(x = HOD_Days, y = TRoad)) + geom_point() + xlab("Hour of Day") + 
  ylab("Road Temperature (°C)")

# ALT
ggplot(Train_MatterMean, aes(x = ALT, y = TRoad)) + geom_point() + xlab("Altitude (m + 10)") + 
  ylab("Road Temperature (°C)") + stat_smooth()

# LAT
ggplot(Train_MatterMean, aes(x = LAT, y = TRoad)) + geom_point() + xlab("Latitude") + 
  ylab("Road Temperature (°C)") + stat_smooth()

# LON
ggplot(Train_MatterMean, aes(x = LON, y = TRoad)) + geom_point() + xlab("Longitude") + 
  ylab("Road Temperature (°C)") + stat_smooth()

# TL
ggplot(Train_MatterMean, aes(x = TL, y = TRoad)) + geom_point() + xlab("Air Temperature (°C)") + 
  ylab("Road Temperature (°C)")

# TD
ggplot(Train_MatterMean, aes(x = TD, y = TRoad)) + geom_point() + xlab("Dew Point Temperature (°C)") + 
  ylab("Road Temperature (°C)") 

# DOY
ggplot(data = Train_set, aes(x = as.factor(DOY_Days), y = TRoad)) + geom_boxplot()
ggplot(data = Train_set, aes(x = as.factor(DOY_Days), y = TL)) + geom_boxplot()


# Water
ggplot(data = Train_set, aes(x = as.factor(Water), y = TRoad)) + geom_boxplot()

# Zand
ggplot(data = Train_set, aes(x = as.factor(Zand), y = TRoad)) + geom_boxplot()

# Klei
ggplot(data = Train_set, aes(x = as.factor(Zand), y = TRoad)) + geom_boxplot()



# And, just for fun, this is what you get when you try to plot ALL THE VARIABLES
ggpairs(Train_set)
