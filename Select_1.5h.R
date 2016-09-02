#############################################################################################################


# This is the script in which the GMS data for the selected 1.5 hours for the 2nd model building step
# is put into a dataframe with the right input format for the ML scripts

# This data will form the test set for the 2nd round of model building


#############################################################################################################

# Empty environment
rm(list=ls())

## Load GMS data files of the relevant days 
Col_Classes_1 <- c("integer", "POSIXct", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor", "numeric", "logical", "logical", "character")

Data_2013_02_20 <- read.csv("/data/project/GMS/data/GMSraw/2013-02-20.csv", colClasses = Col_Classes_1)
Data_2013_02_20$TIMESTAMP <- as.POSIXct(Data_2013_02_20$TIMESTAMP, tz = "GMT")


## Drop variables that are not of intrest by specifying columns you wish to keep
Keep <- c( "LOCATION", "TIMESTAMP", "TW_1","TW_2", "TW_3", "TW_4", "TW_5", 
           "TW_6", "TW_7", "TW_8", "TW_9", "TW_10", "TW_11", "TW_12", "TL", "TD")

Data_2013_02_20 <- Data_2013_02_20[Keep]

## Keep only the hours from 9h until 15h
library(lubridate)

Time_1 <- as.POSIXct("2013-02-20 08:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
Time_2 <- as.POSIXct("2013-02-20 09:30:00", format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
The_Interval <- interval(Time_1, Time_2)

Data_1.5h <- Data_2013_02_20[Data_2013_02_20$TIMESTAMP %within% The_Interval, ]



## Melt the 6h dataframe
# ID vars are LOCATION and TIMESTAMP, TL & TD
library(reshape2)

Data_1.5h <- melt(Data_1.5h, id.vars = c("LOCATION", "TIMESTAMP", "TL", "TD"))
colnames(Data_1.5h)[5] <- "SENSOR"
colnames(Data_1.5h)[6] <- c("TEMP")

# Make the sensor data a character column
Data_1.5h$SENSOR <- as.character(Data_1.5h$SENSOR)

## Download the filtered GMS data for the same day
Col_Classes_2 <- c("integer", "numeric", "character", "POSIXct", "character")

Data_filtered_13_02_20 <- read.csv("/data/project/GMS/data/GMSfiltered/2013-02-20.csv", 
                                   header = FALSE, colClasses = Col_Classes_2)

colnames(Data_filtered_13_02_20) <- c("LOCATION", "TEMP","SENSOR", "TIMESTAMP", "QUALITY")

# Select the same subset for the filtered GMS data
Data_1.5h_filtered <- Data_filtered_13_02_20[Data_filtered_13_02_20$TIMESTAMP %within% The_Interval, ]




## Merge GMS Data & Filtered data by common columns 
# Because the filtered subset contains no NA's in the temp sensors the merged data frame also contains no NA's
library(dplyr)
GMS_1.5h <- right_join(x = Data_1.5h, y = Data_1.5h_filtered, by = c("LOCATION", "TIMESTAMP", "SENSOR", "TEMP"))


# Add an extra column with time as integer (unix time: nr of seconds since Jan 01 1970 UTC)
GMS_1.5h$Unix_Time <- as.numeric(GMS_1.5h$TIMESTAMP)

# Store the GMS six hours data frame as .csv
write.csv(x = GMS_1.5h, file = "/usr/people/kleingel/Projects/MLProject/GMS_1.5h.csv")

# Store the GMS six days data frame as R data
save(x = GMS_1.5h, file = "/usr/people/kleingel/Projects/MLProject/GMS_1.5h.Rda")






