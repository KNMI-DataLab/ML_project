# ML_project

This repository contains the scripts written for an internship project at the Dutch royal meteorological institure (In Dutch: Koninklijk Nederlands Meteorologisch Instituut, or KNMI) to predict road temperatures. Based on measurements of road temperature and meteorological/environmental variables a model is developed to predict road temperatures for all major roads in the Netherlands. To build the model(s) for predicting road temperature we make use of machine learning. An accurate road temperature model used in combination with weather prediction could be used to predict icy roads. Accurate prediction of icy roads allows for early spraying of salt on roads, preventing them from becoming slippery, and thus helping to prevent accidents. 

Several machine learning algorithms are tested: three types of neural networks, a random forest and a decision tree, a simple multilinear regression and a support vactor machine with radial basis function kernel. 

Below a short description of the scripts is provided. 

TW = Road Temperature

------ Scripts for building/analyzing the datasets for the 2nd and 3rd round of modelling -------------------------------------
Met_conditions.Rmd - In this script the daily values of the meteorological measurements at the Bilt are analysed. Several columns are added to the data: Freezing/Stralingsdag/Precip/WindD columns. Based on the data analysis + columns several days are selected as input for the 3rd round of ML modelling. 

Analyze_Days.R - In this script the hourly data of the Bilt station is analyzed. Plots of the diurnal temperature and dew point temperature are made for each of the days that were selected for the 3rd set of model runs. Ice formation/Snowfall/Cloud cover and rainfall are also investigated. A time interval of 6 hours is selected for the 2nd set of model runs.  

Select_Days.R - This is the script in which the GMS data for the 3rd model is put into a dataframe with the right input format for the ML scripts. Six days are selected. The data is merged with the filtered data so that a quality column is included which indicates wether data is "suspect" or "valid". 

Select_6h.R - This is the script in which the data for the selected 6 hours for the 2nd model building step is put into a dataframe with the right input format for the ML scripts. The data is merged with the filtered data so that a quality column is included which indicates wether data is "suspect" or "valid". 

Analyze_GMS_6Days.R - This script contains code to analyze the distribution of road temperature (TW) data in the GMS data set. It includes a function to plot the diurnal temperature for each station, per sensor, per day. The script also contains code for a simple histogram of TW, boxplots of the suspect and valid data and boxplots of the temperature per station, per day. 

-------- Scripts for testing functions that are relevant to the project -------------------------------------------------------

Test_merge_join.R - Here we test wether the merge or the join function (dplyr package) is the fastest for merging data frames. This is especially relevant because we will later merge (very) large data frames. A faster merge will save much time. Spoilers: the join fucntion is 8x faster than merge for this small data set and has been shown to be even faster (compared to merge) on large data sets. 

Test_Time_Slice.R - In this script the time slice function from the caret package is tested. This script was copy pasted from a Stackoverflow answer. (Stackoverflow post: http://stackoverflow.com/questions/24758218/time-series-data-spliting-and-model-evaluation)

