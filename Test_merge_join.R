##########################################################################################################


                # Here we test which is faster: merge or inner_join
                # This is especially relevant for merging the environmental and GMS data


##########################################################################################################

# Empty environment
rm(list=ls())

# install.packages("dplyr")

# Load from USB
load("/usr/people/kleingel/Projects/MLProject/Data_10min.Rda")
#load("/usr/people/kleingel/Projects/MLProject/Data_10min.Rda")

# Remove data that is not valid
Data_10min <- Data_10min[Data_10min$QUALITY == "valid", ]

## Drop the quality column
Data_10min <- Data_10min[ ,-7]

# Load from USB
load("/usr/people/kleingel/Projects/MLProject/Env_Data.Rda")

#load("/usr/people/kleingel/Projects/MLProject/Env_Data.Rda")

## Merge subset and environmental data
system.time(data_GMS<-merge(Data_10min,Env_Data_4,by.x=c("LOCATION","SENSOR"),by.y=c("MISD","SENSOR")))

## Joining with dplyr gives very many rows ????
library(dplyr)
system.time(data_GMS_2 <- inner_join(x = Data_10min, y = Env_Data_4, by = c("LOCATION" = "MISD", "SENSOR" = "SENSOR")))













































