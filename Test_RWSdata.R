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
The_link <- "WFS:http://geoservices.rijkswaterstaat.nl/kerngisdroog/dnh?"

# Read in an OGR data source, give a summary of what layers/information is in the GIS datasource
ogrinfo(The_link, layer = "AAA2100",so=TRUE)

# What layers are in the dataset?
ogrListLayers(The_link)

# converts to ESRI Shapefile?
# https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.1.7/topics/ogr2ogr 
ogr2ogr(The_link, "AAA2100.shp", layer = "AAA2100")


deklagen_DNH<-readOGR("AAA100.shp","AAA2100")

deklagen_DNH<-as(deklagen_DNH,"SpatialPolygons") # in RD-coords

#GMS data
MetaData<- read.csv("/data/project/GMS/data/auxcillary_data/MetadataGMS/metadataGMScoding.csv", header = TRUE)
coordinates(MetaData)<-~loc_lon+loc_lat
MetaData<-SpatialPoints(MetaData) # in LAT LON
proj4string(MetaData)<-CRS("+init=epsg:4326") #dit is WGS84

RDproj4string<-CRS("+init=epsg:28992") #projectie van deklagen 
#regel met spTransform ertussen
deklagen_DNH_WGS84<-spTransform(deklagen_DNH,crs(MetaData))

extract(deklagen_DNH,MetaData) #extract(spatialpolygon,spatialpoints)
over(MetaData,deklagen_DNH)
# (1) laden van de coordinaten GMS
# (2) een spatial object van maken
# (3) met spTransform zelfde coordinaten systeem
# (4) uit de shape file de punt informatie halen met extract
plot(deklagen_DNH)
