#### Set-up ####

# Packages 

library(tmap)
library(tidyverse)
library(dplyr)
library(sp)
library(readxl)
library(rgdal)
library(readr)

# Data files

## outcome data
ej_ga <- read_csv("Data/ej_ga.csv", 
                  col_types = cols(...1 = col_skip())) %>% 
  select('ID', 'DSLPM', 'CANCER', 'RESP')

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

# cleaning EJScreen data 

ej_ga2 <- ej_ga %>% 
  mutate(GEOID20 = substr(ej_ga$ID, 1, 11)) %>% 
  select(-'ID')

ej_ga2 <- ej_ga2[!duplicated(ej_ga2$GEOID20),]

ej_ga2 <- sp::merge(ga_tracts_20, ej_ga2, 
                    by = 'GEOID20', 
                    all.y = T,
                    duplicateGeoms = T,
                    na.strings = 'Missing')

full_data <- sp::merge(ej_ga2, HOLC_score2, 
                       by = 'GEOID20', 
                       all.y = T,
                       duplicateGeoms = T,
                       na.strings = 'Missing')

summary(full_data)

writeOGR(obj=full_data, dsn="Data/tempdir", layer="full_data", driver="ESRI Shapefile")

#### final working data ####

full_data <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data") # all census tracts

full_data_georgia <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_georgia") # only have census tracts with HOLC data
full_data_atlanta <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_atlanta") # only have census tracts with HOLC data
full_data_augusta <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_augusta") # only have census tracts with HOLC data
full_data_macon <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_macon") # only have census tracts with HOLC data
full_data_savannah <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_savannah") # only have census tracts with HOLC data
full_data_columbus <- readOGR(dsn=path.expand("Data/tempdir"),layer="full_data_columbus") # only have census tracts with HOLC data

#### Exploring data ####

a <- tm_shape(full_data_atlanta) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Atlanta - Diesel PM')

b <- tm_shape(full_data_augusta) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Augusta - Diesel PM')

c <- tm_shape(full_data_macon) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Macon - Diesel PM')

d <- tm_shape(full_data_savannah) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Savannah - Diesel PM')

e <- tm_shape(full_data_columbus) +
  tm_fill('DSLPM',
          style = 'quantile',
          palette = 'BuPu') +
  tm_borders() +
  tm_layout(main.title = 'Columbus - Diesel PM')

tmap_arrange(a, b, c, d, e)

#### Example Code ####

# Reading and writing a .shp file 
x <- readOGR(dsn=path.expand("Data/tempdir"),layer="HOLC_full")
writeOGR(obj=full_data, dsn="Data/tempdir", layer="full_data", driver="ESRI Shapefile")

# finding nas 
apply(is.na(ej_ga2), 2, sum)