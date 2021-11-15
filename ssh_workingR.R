# Susan's Working File 

# Packages 

library(tidyverse)
library(raster)
library(rgdal)
library(sf)
library(tmap)
library(readxl)

# Data

## outcome data
EJscreen <- read.csv("Data/ej_ga.csv")

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")