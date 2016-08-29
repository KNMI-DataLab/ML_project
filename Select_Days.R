#############################################################################################################


                  # This is the script in which the days for the 2nd and 3rd model
                  # run are analysed.


#############################################################################################################

# Empty environment
rm(list=ls())

## Load GMS data files of the relevant days 
Col_Classes_1 <- c("integer", "POSIXct", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor", "numeric", "logical", "logical", "character")

Data_2013_12_03 <- read.csv("/data/project/GMS/data/GMSraw/2013-12-03.csv", colClasses = Col_Classes_1)
Data_2013_12_03$TIMESTAMP <- as.POSIXct(Data_2013_12_03$TIMESTAMP, tz = "GMT")

Data_2016_01_09 <- read.csv("/data/project/GMS/data/GMSraw/2016-01-09.csv", colClasses = Col_Classes_1)
Data_2016_01_09$TIMESTAMP <- as.POSIXct(Data_2016_01_09$TIMESTAMP, tz = "GMT")

Data_2014_12_28 <- read.csv("/data/project/GMS/data/GMSraw/2014-12-28.csv", colClasses = Col_Classes_1)
Data_2014_12_28$TIMESTAMP <- as.POSIXct(Data_2014_12_28$TIMESTAMP, tz = "GMT")

Data_2015_03_24 <- read.csv("/data/project/GMS/data/GMSraw/2015-03-24.csv", colClasses = Col_Classes_1)
Data_2015_03_24$TIMESTAMP <- as.POSIXct(Data_2015_03_24$TIMESTAMP, tz = "GMT")

Data_2015_03_09 <- read.csv("/data/project/GMS/data/GMSraw/2015-03-09.csv", colClasses = Col_Classes_1)
Data_2015_03_09$TIMESTAMP <- as.POSIXct(Data_2015_03_09$TIMESTAMP, tz = "GMT")

Data_2009_11_24 <- read.csv("/data/project/GMS/data/GMSraw/2009-11-24.csv", colClasses = Col_Classes_1)
Data_2009_11_24$TIMESTAMP <- as.POSIXct(Data_2009_11_24$TIMESTAMP, tz = "GMT")















































