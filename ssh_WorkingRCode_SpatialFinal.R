#### Set-up ####

# Packages 

library(tmap)
library(tidyverse)
library(dplyr)
library(sp)
library(readxl)
library(rgdal)

# Data

## outcome data (making everything numeric instead of character)
ga_hi <- read_excel("Data/nata2014_ga_allhi.xlsx")

ga_hi <- as.data.frame(ga_hi)

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")

## Importing Georgia Census Tract Geographic Boundary file
## updated 2020 data
 
ga_tracts_20 <- readOGR(dsn=path.expand("Data/tl_2020_13_all"),layer="tl_2020_13_tract20")

#### Data editing ####

ga_hi <- rename(ga_hi, GEOID20 = Tract)

ga_hi2 <- sp::merge(ga_tracts_20, ga_hi,
                    by = 'GEOID20',
                    all.y = T,
                    duplicateGeoms = T,
                    na.strings = 'Missing')
  
# Cleaning HOLC score data
HOLC_score2 <- HOLC_score %>% 
  filter(substr(GEOID20,1,2) == "13") # restricting to only GA

full_data <- sp::merge(ga_hi2, HOLC_score2, 
                       by = 'GEOID20', 
                       all.y = T,
                       duplicateGeoms = T,
                       na.strings = 'Missing')

summary(full_data)

#### Exploring data ####

full_savannah <- full_data[full_data$COUNTYFP20 == "051",]


tm_shape(full_savannah) + 
  tm_fill('Developmental_HI',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders()

tm_shape(full_savannah) + 
  tm_fill('Reproductive_HI',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders()


