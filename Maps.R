# install.packages(readr)
#install.packages("sf")
library(sf)
#install.packages("raster")
library(raster)
library(dplyr)
#install.packages("spData")
library(spData)
install.packages('spDataLarge', repos='https://nowosad.github.io/drat/',type='source')
library(spDataLarge)
#https://geocompr.robinlovelace.net/adv-map.html
install.packages("tmap")
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
install.packages("mapview")
library(mapview) # for interactive maps
library(ggplot2) # tidyverse data visualization package
library(shiny)   # for web applications
library(sp)
library(rgdal) # the library we'll be using
install.packages("downloader")
library(readr)
# Read geojson data for nepal with districts
library(tidyverse)
library(geojsonio)
library(sf)



America <- geojson_read("america.geojson",  what = "sp")
#tidy data for ggplot2
library(broom)
America_fortified <- tidy(America)

ggplot() +
  geom_polygon(data = America_fortified, aes( x = long, y = lat, group = group, color='gray', alpha=0.7)) +
  theme_void() +
  coord_sf(expand = FALSE)





