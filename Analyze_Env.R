##############################################################################################################


        # In this script the environmental data is analyzed.
        # Distributions are analysed and plotted
        # Correlations between variabeles are analyzed 


##############################################################################################################

# Empty environment
rm(list=ls())

# Read in environmental data

load("/usr/people/kleingel/Projects/MLProject/Env_Data.Rda")

# Plot histograms of LAT/LON/ALT
# The altitude data is especially skewed
hist(Env_Data_4$LAT, main = "Histogram of Latitude")
hist(Env_Data_4$LON, main = "Histogram of Longitude")
hist(Env_Data_4$ALT, main = "Histogram of Altitude")

# Shapiro-Wilk test
# If the Shapiro test finds a p-value HIGHER than 0.05 then you have proven that the data is not normally
# distributed. However, if p < 0.05 you have not proven that the data is normally distributed.
# See research log for the Stackoverflow comments discussing this. 
# ALT, LAT and LON all have p < 0.05
shapiro.test(Env_Data_4$LAT)
shapiro.test(Env_Data_4$LON)
shapiro.test(Env_Data_4$ALT)

# Q-Q plots
# The qqplots suggest that ALT is definately not normally distributed.
# LAT and LON are approximately normally distributed
qqnorm(Env_Data_4$LAT)
qqnorm(Env_Data_4$LON)
qqnorm(Env_Data_4$ALT)

# Determine the skewness of LAT/LON/ALT
# LAT is slightly right skewed
# LON is slightly left skewed
# ALT is right skewed
library(e1071)
skewness(Env_Data_4$LAT)
skewness(Env_Data_4$LON)
skewness(Env_Data_4$ALT)

# Determine kurtosis
# The LAT and LON are slightly flattened distributions
# ALT is strongly peaked (kurtosis is more than 26) (also called leptokurtic)
kurtosis(Env_Data_4$LAT)
kurtosis(Env_Data_4$LON)
kurtosis(Env_Data_4$ALT)


# You can conclude that the altitude has a positive skew = right skewed


