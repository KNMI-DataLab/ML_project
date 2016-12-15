# In this script we test whether we can import RWS data with road cover information from the 
# http://geoservices.rijkswaterstaat.nl/services-index.html website

# This code was provided by M. Koole from the RWS datalab and adapted slightly by Eva Kleingeld 
# (KNMI datalab intern)


#Empty environment
rm(list=ls())

# If needed, install packages
# install.packages("rgdal")
# install.packages("gdalUtils")

# Load libraries
library(rgdal)
library(gdalUtils)

# The link
The_link<-"WFS:http://geoservices.rijkswaterstaat.nl/kerngisdroog/dnh?service=WFS&request=getCapabilities"

# Read in an OGR data source, give a summary of what layers/information is in the GIS datasource
ogrInfo(The_link)

# What layers are in the dataset?
ogrListLayers(The_link)

# converts to ESRI Shapefile?
# https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.1.7/topics/ogr2ogr 
ogr2ogr(The_link, "AAA100.shp", layer = "AAA100")


deklagen_DNH<-readOGR("AAA100.shp","AAA100")

plot(deklagen_DNH)
