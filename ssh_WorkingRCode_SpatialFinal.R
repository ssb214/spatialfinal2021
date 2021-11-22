#### Set-up ####

# Packages 

library(tmap)
library(tidyverse)
library(dplyr)
library(sp)
library(readxl)

# Data

## outcome data (making everything numeric instead of character)
ga_hi <- read_excel("Data/nata2014_ga_allhi.xlsx", 
                    col_types = c("numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric"))

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")

#### Data editing ####

## add leading zero to GeoID
HOLC_score$GEOID20 <- paste0("0", HOLC_score$GEOID20)


#### Exploring data ####


