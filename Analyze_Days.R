##############################################################################################################


                  #Analyse the day(s) for the 2nd and 3rd round of ML model building


#############################################################################################################

# Open the files which contain the relevant data, multiply T columns by 0.1 and select the correct days
Data_2001_2010 <- read.table("/usr/people/kleingel/Downloads/Bilt Data/uurgeg_260_2001-2010.txt", header = TRUE, sep = ",")
Data_2001_2010$T <- (Data_2001_2010$T * 0.1)
Data_2001_2010$T10 <- (Data_2001_2010$T10 * 0.1)
Data_2001_2010$TD <- (Data_2001_2010$TD * 0.1)

Data_2009_11_24 <- Data_2001_2010[Data_2001_2010$YYYYMMDD == as.integer(20091124), ]

Data_2011_2020 <- read.table("/usr/people/kleingel/Downloads/Bilt Data/uurgeg_260_2011-2020.txt", header = TRUE, sep = ",")
Data_2011_2020$T <- (Data_2011_2020$T * 0.1)
Data_2011_2020$T10 <- (Data_2011_2020$T10 * 0.1)
Data_2011_2020$TD <- (Data_2011_2020$TD * 0.1)

Data_2013_12_03 <- Data_2011_2020[Data_2011_2020$YYYYMMDD == 20131203, ]
Data_2014_12_28 <- Data_2011_2020[Data_2011_2020$YYYYMMDD == 20141228, ]
Data_2015_03_09 <- Data_2011_2020[Data_2011_2020$YYYYMMDD == 20150308, ]
Data_2015_03_24 <- Data_2011_2020[Data_2011_2020$YYYYMMDD == 20150324, ]
Data_2016_01_09 <- Data_2011_2020[Data_2011_2020$YYYYMMDD == 20160109, ]


# Put all of the selected days in one data frame
All_Days <- rbind.data.frame(Data_2009_11_24, Data_2013_12_03, Data_2014_12_28,
                             Data_2015_03_09, Data_2015_03_24, Data_2016_01_09)

# Add a stralingsdag column
All_Days$Stralingsdag <- ifelse((All_Days$YYYYMMDD == 20131203)|(All_Days$YYYYMMDD == 20141228)|(All_Days$YYYYMMDD == 20150308),
                                "Stralingsdag", "Cloudy")



# Plot the hourly temperature per day, of all days, in one graph 
# In order to color the plot per day, make YYYYMMDD a factor
library(ggplot2)

All_Days$YYYYMMDD <- as.factor(All_Days$YYYYMMDD)

ggplot(data = All_Days, aes(x = HH, y = T, colour = YYYYMMDD)) + geom_point() + geom_line() +
                        geom_hline(yintercept=0, color = "#0033FF") + 
                        annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = 0, fill = "#6699FF", 
                                 alpha = 0.1, color = NA)+
                        ggtitle("Diurnal temperature at the Bilt")+
                        xlab("Hour of the day")+
                        ylab(expression("Temperature at 1.5m height (" *
                                          degree * "C)"))+
                        scale_colour_discrete(name="Days", 
                                              labels = c("2009-11-24", "2013-12-03", "2014-12-28",
                                                         "2015-03-09", "2015-03-24", "2016-01-09"))

# Plot the dew point temperature in the same way 
ggplot(data = All_Days, aes(x = HH, y = TD, colour = YYYYMMDD)) + geom_point() + geom_line() +
  geom_hline(yintercept=0, color = "#0033FF") + 
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = 0, fill = "#6699FF", 
           alpha = 0.1, color = NA)+
  ggtitle("Dew point temperature at the Bilt")+
  xlab("Hour of the day")+
  ylab(expression("Dew point temperature at 1.5m height (" *
                    degree * "C)"))+
  scale_colour_discrete(name="Days", 
                        labels = c("2009-11-24", "2013-12-03", "2014-12-28",
                                   "2015-03-09", "2015-03-24", "2016-01-09"))

# Plot the cloud cover
ggplot(data = All_Days, aes(x = HH, y = N, colour = Stralingsdag)) + geom_point() + geom_line() + 
        facet_grid(.~ YYYYMMDD) + ggtitle("Diurnal cloud cover at the Bilt")+
        xlab("Hour of the day") + ylab("Cloud cover (octants)")
  

# Plot ice formation
ggplot(data = All_Days, aes(x = HH, y = Y, colour = YYYYMMDD)) + geom_line()

# No snow on any of the days
ggplot(data = All_Days, aes(x = HH, y = S, colour = YYYYMMDD)) + geom_line()

# Rainfall yes/no
# I do not plot rain intensity here because there are negative precipitation values ?? Why??
ggplot(data = All_Days) + geom_bar(aes(x = HH, y = R), stat="identity", colour = "blue") + facet_grid(.~ YYYYMMDD)





