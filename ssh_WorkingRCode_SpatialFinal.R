#### Set-up ####

# Packages 

library(sf)
library(tmap)
library(tidyverse)
library(dplyr)

# Data

## outcome data
EJscreen <- read.csv("Data/ej_ga.csv")

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")

#### Data editing ####

## add leading zero to GeoID
HOLC_score$GEOID20 <- paste0("0", HOLC_score$GEOID20)


#### Exploring data ####

tm_shape(HOLC_map) +
  tm_polygons()

View(EJscreen)
