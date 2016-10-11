# ML_project

This repository contains the scripts written for an internship project at the Dutch royal meteorological institure (In Dutch: Koninklijk Nederlands Meteorologisch Instituut, or KNMI) to predict road temperatures. Based on measurements of road temperature and meteorological/environmental variables a model is developed to predict road temperatures for all major roads in the Netherlands. To build the model(s) for predicting road temperature we make use of machine learning. An accurate road temperature model used in combination with weather prediction could be used to predict icy roads. Accurate prediction of icy roads allows for early spraying of salt on roads, preventing them from becoming slippery, and thus helping to prevent accidents.  

Several machine learning algorithms are tested: three types of neural networks, a random forest and a decision tree, a simple multilinear regression and a support vector machine with radial basis function kernel. 

Below a short description of the scripts is provided. 

The README description has been divided into several parts.

*First, the scripts for the building and analysis of the Environmental data set are described.
*Secondly, the script for building the 5/10 minute subsets for the first round of model building are decsribed.
*Thirdly, the script for building the 'miniature' models is described. 
*Next, the scripts for building and analyzing the datasets needed for the 2nd and 3rd rounds of model building are explained. 
*Finally, the scripts used for testing relevant fuctions are described. These scripts have been used to test functions which may be usefull for the project, but which are complicated. The working of the functions is analyzed by (for example) testing the distributions of TW data before and after applying one of the functions.  

Relevant abbreviations:
TW = Road Temperature
ML = Machine Learning

------ Scripts for building/analyzing the Environmental dataset --------------------------------------------------------------------
Environmental_Data.Rmd - Here the environmental dataset is built. In this script several seperate datasets with environmental data are read in. This data is then combined by station number and LAT/LON. We use the Rijksdriehoek LAT/LON and drop the 'normal' LAT/LON. Measurements from stations which have taken no measurements since 2014 and RWS test stations are removed from the dataset. The category 'Moerig op Zand' occurs very sparsely and is therefore added to the category "Zand". The CODE column is split into multiple columns (One for each number in the CODE line). Next, dummy variables are created for the categorical data. These dummy variables are stored as integers instead of factors, because neural networks can not handle factors as data input. Finally, the dataframe is stored. 

Analyze_Env.R - In this script the environmental dataset is analyzed. The distribution of the LAT/LON/ALT data is analyzed with histograms and a shapiro test. The skewness and kurtosis are also analyzed. Based on these analyses we can determine that ALT is definately positively skewed and leptokurtic.   

------ Script for building/analyzing 5/10 minute GMS subset ------------------------------------------------------------------------
miniSubset.Rmd - This script can be used to build either a 5 minute or a 10 minute 'miniature' subset. This small subset is used in the first round of model building. 

One day of data is read in and with the lubridate package a time interval is defined. This time interval is used to 'cut' a 10 minute slice of data from the one day GMS data set. Next, the subset is melted to the correct shape and merged with a filtered subset, for the same time interval. A new Time column is added with the Linux time (seconds passed since 1970). This is because the POSIXct TIMESTAMP column can not be used as input by any of the ML algorithms: It is not an accepted input format. 

This script also contains some data analysis. First the amount of suspect data in TEMP, TL and TD is plotted. Next, it is tested how much of the original subset data was NA. This number is quite high because not all stations have the full 12 road temperature sensors. If a station does not have 12 sensors it will register NA for all sensors that are not in use. 

Finally, the subset is saved as an Rdata file (which can quickly be loaded in with the load function) and as a .csv file. 



------ Script for building the 'miniature' models ---------------------------------------------------------------------------
miniML.Rmd - This script contains the code to build 'miniature models'. We call these models mini models because they are built on only 5 minutes of data. This small amount of training data is not enough to build a reliable model for predicting TW. However, it is useful to test the code you use to build the different models. 

The first part of the script builds the test and train data sets. First, the 10 minute GMS subset is read in. Next, all data which is not labeled as 'valid' is removed. Now that we have only 'valid' data remaining we merge the GMS data with the environmental data. This dataset is then split into train and test datasets. Each train/test set contains 5 minutes of data. The LOC/SENSOR/TIMESTAMP columns are dropped from the test and train sets because these columns can not be used as input by most ML algorithms. 

The second part of the script tests how centering and scaling with the preProcess function works. To test the effect of centering and scaling histograms are plotted before and after running the preProcess function. The preProcess function is tested on 2 sets of data and finally applied to the train and test data. 

In the third part of the script the test and train data are split into input (: predictors) and output (: target variables). 
There are two types of input. The first (Train/Test_X_1) does not include the air and dew point temperature, the second (Train/Test_X_2) does. 

The next sections of the script handle the actual model building. All model building scripts follow the pattern: 
* train model
* get RMSE/summary/plots of trained model
* predict based on trained model and test set
* plot predicted versus measured values 


The fourth part of the script is where the first model is built! This model is built based on a linear regression algorithm. We use the caret package for building the model, even though you can also use basic R. There are two formats to train a model with the caret package. The first is by means of a formula and a data set. The second is by means of specifying an x (:predictors) and y (: target variable). We chose the latter method. After the model is built the summary and error measures are analysed. Next, we use the test set and the trained model to predict values. To test how well the model predicts we plot the predicted values versus the measured values. This is done with a caret plotting routine and with ggplot. We use the function extractPrediction to make the model predictions. You can also use the fucntion predict, but extractPrediction handily puts the results in a data frame and if necessary this fucntion can handle multiple models at once. 

Parts 5-8 contain the neural network models.
Part 5 builds a model with the neuralnet algorithm. This script still contains some bugs. Sometimes the model works with both types of input, sometimes it does not. Sometimes the model can handle multiple layers, sometimes it can not. Perhaps this has something to do with the memory running full. Sometimes the plotting routine can plot and save the neural network structure, sometimes it can not.  This latter problem seems to be a bug. (https://github.com/IRkernel/IRkernel/issues/337) The neuralnet function also does not seem to work within the train environment from caret. If we use the neuralnet funtion straight from the neuralnet package it does work. Code follows standard structure. 

Part 6 contains the multilayer perceptron. Code follows standard setup except for extra code for the plotting routine and an iterative error plot. 

Part 7 contains the Radial Basis Function Neural Network. This model again does not seem to work within the train environment, but it does work from the rbf package. Code follows standard structure. 

Part 8 contains the decision tree.  
The decision tree script contains two different plotting routines: a basic and a 'fancy'plotting routine. The latter routine is taken from the rattle package. Next, several types of variable importance plots are made. Finally, values are predicted and plotted. 

Part 9 contains teh random forest. 
This code conatins a level plot indictaing how many trees need to be built to reduce the error. Next, several types of importance plots are tested. Partial plots are also made (within a loop) to test the effect of a certain predictor on the predicted target outcome. Then, again, predictions are made and plotted. 

Part 10, the final part of the script, contains the code for the Support Vector Machine. This code follows the standard setup. 

------ Scripts for building/analyzing manually selected subsets of data of 6h/1.5h -----------------------------------------
In the second round of modeling we first wanted to build models with a 6h train and 1.5h test set that were manually selected. To this end scripts to select the data were written, as well as scripts to analyze and preprocess these data sets. However, it turned out that these test/train sets had different correlations between the predictors, which would mean that they could not be used to test which ML algorithms could model TW best. We therefore chose to select a 6h train and 1.5h test subset from a larger dataset, so that correlations in test/train sets would be similar, see the section below. The scripts in this section were thus not used for the 2nd modeling round. However, in order to have a complete README file they are described here as well. 

Select_6h.R - This is the script in which the data for the selected 6 hours for the 2nd model building step is put into a dataframe with the right input format for the ML scripts. The data is merged with the filtered data so that a quality column is included which indicates wether data is "suspect" or "valid". 

Select_1.5h.R - In this script the test dataset for the 2nd round of model building is built. he data is merged with the filtered data so that a quality column is included which indicates wether data is "suspect" or "valid". 

Build_6h_dataset

Round2_Data_and_PreProcess

Data_PreProc_DummyV



------ Scripts for building/analyzing the datasets for the 2nd round of modelling -----------------------------------------
Met_conditions.Rmd - In this script the daily values of the meteorological measurements at the Bilt are analysed. Several columns are added to the data: Freezing/Stralingsdag/Precip/WindD columns. Based on the data analysis + columns several days are selected. 

Analyze_Days.R - In this script the hourly data of the Bilt station is analyzed. Plots of the diurnal temperature and dew point temperature are made for each of the days that were selectedin the Metconditions script. Ice formation/Snowfall/Cloud cover and rainfall are also investigated. 

Select_Days.R - This is the script in which the GMS data is put into a dataframe with the right input format for the ML scripts. Six days are selected, based on the Metconditions and Analyze days scripts. The data is merged with the filtered data so that a quality column is included which indicates wether data is "suspect" or "valid". 

Analyze_GMS_6Days.R - This script contains code to analyze the distribution of road temperature (TW) data in the GMS data set. It includes a function to plot the diurnal temperature for each station, per sensor, per day. The script also contains code for a simple histogram of TW, boxplots of the suspect and valid data and boxplots of the temperature per station, per day. 

Build_GMS_Round2 - In this script a test/train GMS set is selected from the 6 days that were selected in the Select_Days.R script. We do this with the createDataPartition function from the caret package. The distribution of data in the test/train sets is analyzed by means of histograms and correlation plots. Finally, the data is saved to a .Rdata file at the end of the script. 


Preproc_Round2 - Here the test/train sets built in the Build_GMS_Round2 script are subsetted so that they only include valid data. Next, the valid data is split into test predictors/target variables and train predictors/target variables. Altitude is heightened by 10m and temperatures are put in Kelvin instead of Celsius. Data is preprocessed using the preProcess function, the transformations that are applied are:
+ Zero variance removal
+ BoxCox transform
+ centering
+ scaling
+ principal component analysis
Some optional code is included for analyzing the remaining PC's. Finally, the resulting predictor sets and target variables are saved to .Rdata files





-------- Scripts for testing functions that are relevant to the project -------------------------------------------------------

Test_merge_join.R - Here we test wether the merge or the join function (dplyr package) is the fastest for merging data frames. This is especially relevant because we will later merge (very) large data frames. A faster merge will save much time. Spoilers: the join fucntion is 8x faster than merge for this small data set and has been shown to be even faster (compared to merge) on large data sets. 

Test_Time_Slice.R - In this script the time slice function from the caret package is tested. This script was copy pasted from a Stackoverflow answer. (Stackoverflow post: http://stackoverflow.com/questions/24758218/time-series-data-spliting-and-model-evaluation)

Test_CreateDataPartition.R - This script is used to test how the create data partition script from the caret package works. First, the function is used to build train and test sets. Next, histograms are plotted (side by side) of the original TW data and of the train/test TW data. These histograms show that all the data sets hav approximately the same distribution. Next, the distributions of other variables are checked in the same manner. This is done within a for loop. Finally, the relative proportion of sensors per set is tested by means of a prop.table.    

Test_SavePlotLoop.R - Script that tests how you can best save a plot to a list within a loop. Makes use of the economics dataset. Tests for loop with basic plotting/qplot/ggplot as well as apply and lapply with qplot. The best option is to use ggplot + for loop, see script for more details. 

Test_PreProcess.Rmd - This script is used to test how the preProcess function from the caret package transforms a set of predictors when you apply several different preprocessing methods. To test this we make use of the manually selected 6h GMS data set + environmental data. The distribution of the data before and after transformation is analyzed by means of histograms and correlation plots. Dummy variables are not included in the analysis. 

-------- Presentations/demo scripts -------------------------------------------------------
ML_project/Presentatie_RWS.Rmd
