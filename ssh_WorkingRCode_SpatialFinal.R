#### Set-up ####

# Packages 

library(tmap)
library(tidyverse)
library(dplyr)
library(sp)
library(readxl)
library(rgdal)
library(readr)

# Data

## outcome data
ej_ga <- read_csv("Data/ej_ga.csv", 
                  col_types = cols(...1 = col_skip()))

## exposure geometry data 
HOLC_map <- readOGR(dsn=path.expand("Data/HRS2020-Shapefiles/HRS2020"),
                    layer="HRS2020")
## exposure attribute data
HOLC_score <- read_excel("Data/Historic Redlining Score 2020.xlsx")

## Importing Georgia Census Tract Geographic Boundary file
## updated 2020 data
 
ga_tracts_20 <- readOGR(dsn=path.expand("Data/tl_2020_13_all"),layer="tl_2020_13_tract20")

#### Data editing ####

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

